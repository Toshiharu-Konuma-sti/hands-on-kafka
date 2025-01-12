/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package jp.sios.apisl.handson.kafka.streams;

import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.KafkaStreams;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.StreamsConfig;
import org.apache.kafka.streams.Topology;
import org.apache.kafka.streams.kstream.ValueMapper;

import java.util.Arrays;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.concurrent.CountDownLatch;

/**
 * In this example, we implement a simple MyApp program using the high-level Streams DSL
 * that reads from a source topic "my-streams-plaintext-input", where the values of messages represent lines of text;
 * the code split each text line in string into words and then write back into a sink topic "my-streams-linesplit-output" where
 * each record represents a single word.
 */
public class MyHandsOn {

	public static void main(String[] args) throws Exception {

		ResourceBundle rb = ResourceBundle.getBundle("application");
		String bootstrap = rb.getString("bootstrap");
		System.out.println("* bootstrap server = [" + bootstrap + "]");

		Properties props = new Properties();
		props.put(StreamsConfig.APPLICATION_ID_CONFIG, "streams-linesplit");
		props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrap);
		props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
		props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());

		final StreamsBuilder builder = new StreamsBuilder();

		builder.<String, String>stream("my-streams-plaintext-input")
			.flatMapValues(new ValueMapper<String, Iterable<String>>() {
				@Override
				public Iterable<String> apply(String value) {
					String result = this.invertCase(value);
					return Arrays.asList(result);
				}
				private String invertCase(String str) {
					char[] chars = str.toCharArray();
					for (int i = 0; i < chars.length; i++)
					{
						chars[i] = Character.isUpperCase(chars[i])
								? Character.toLowerCase(chars[i])
								: Character.toUpperCase(chars[i]);
					}
					return new String(chars);
				}
			})
			.to("my-streams-myhandson-output");

		final Topology topology = builder.build();
		final KafkaStreams streams = new KafkaStreams(topology, props);
		final CountDownLatch latch = new CountDownLatch(1);

		// attach shutdown handler to catch control-c
		Runtime.getRuntime().addShutdownHook(new Thread("streams-shutdown-hook") {
			@Override
			public void run() {
				streams.close();
				latch.countDown();
			}
		});

		try {
			streams.start();
			latch.await();
		} catch (Throwable e) {
			System.exit(1);
		}
		System.exit(0);
	}
}
