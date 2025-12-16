FROM flink:2.1.1-java21

# 1. Python3 と pip のインストール
RUN apt-get update -y && \
    apt-get install -y python3 python3-pip python3-dev && \
    rm -rf /var/lib/apt/lists/*

# 2. "python" コマンドで python3 が動くようにシンボリックリンク作成
RUN ln -s /usr/bin/python3 /usr/bin/python

# 3. PyFlinkライブラリのインストール
# (Flinkサーバーのバージョンと合わせる必要があります)
RUN pip3 install apache-flink==2.1.1

# 4. Kafka Connector JAR のダウンロードと配置
RUN wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/4.0.1-2.0/flink-sql-connector-kafka-4.0.1-2.0.jar
