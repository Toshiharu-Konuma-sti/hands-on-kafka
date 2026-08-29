# Kafka Event Streaming Playground

[![GitHub License](https://img.shields.io/github/license/Toshiharu-Konuma-sti/hands-on-kafka?style=flat-square)](https://github.com/Toshiharu-Konuma-sti/hands-on-kafka/blob/main/LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/Toshiharu-Konuma-sti/hands-on-kafka?style=flat-square)](https://github.com/Toshiharu-Konuma-sti/hands-on-kafka/commits)
[![Docker](https://img.shields.io/badge/Docker-Container-blue?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![Apache Kafka](https://img.shields.io/badge/Apache%20Kafka-Broker-231F20?style=flat-square&logo=apachekafka&logoColor=white)](https://kafka.apache.org/)
[![Apache Flink](https://img.shields.io/badge/Apache%20Flink-Stream%20Processing-E6526F?style=flat-square&logo=apacheflink&logoColor=white)](https://flink.apache.org/)
[![Debezium](https://img.shields.io/badge/Debezium-CDC-292A2A?style=flat-square&logo=debezium&logoColor=white)](https://debezium.io/)
[![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com/)

> **Practical resources and Docker configurations for hands-on learning of event streaming, stream processing (Flink / Kafka Streams), schema management, and CDC using Apache Kafka.**

## 📖 Overview

This repository is a comprehensive starter kit designed for hands-on learning of **Apache Kafka and the Event Streaming Ecosystem**.  
By leveraging Docker Compose, you can instantly spin up a full real-time data pipeline environment on your local machine to experiment with event streaming, real-time stream transformations (Flink SQL, Table API, DataStream API, Kafka Streams), schema validation, Change Data Capture (CDC), and partition rebalancing.

### 🚀 Tech Stack

- **Apache Kafka**: Core event streaming platform running in ZooKeeper-less KRaft mode.
- **AKHQ**: Web UI for Kafka cluster management, topic browsing, and schema inspection.
- **Apache Flink**: Distributed stream processing engine supporting Flink SQL, Table API, and DataStream API (PyFlink).
- **Apicurio Registry**: Schema Registry for data quality control and schema validation.
- **Kafka Streams**: Java-based client library for building lightweight stream processing applications.
- **Debezium Connector for MySQL**: Change Data Capture (CDC) component to stream database change events.
- **MySQL**: Relational database serving as the CDC source.

## 📚 How to Use (Step-by-Step Guide)

For detailed, step-by-step instructions on setting up and running this hands-on environment, please refer to the following article:

👉 **[Apache Kafka で体験する『イベントストリーミング入門』 - SIOS Tech Lab](https://tech-lab.sios.jp/archives/54310)**

*(Note: The article is written in Japanese. It guides you through Docker Compose setup, real-time message stream transformations, schema validation, CDC integration, and partition load balancing/rebalancing practice.)*