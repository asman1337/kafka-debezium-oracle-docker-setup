# Developer: Asman Mirza
# Email: rambo007.am@gmail.com
# Date: 24 January, 2024

FROM quay.io/debezium/connect:latest
ENV KAFKA_CONNECT_JDBC_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-jdbc

ENV MAVEN_DEP_DESTINATION=$KAFKA_HOME/libs \
    ORACLE_JDBC_REPO="com/oracle/database/jdbc" \
    ORACLE_JDBC_GROUP="ojdbc8" \
    ORACLE_JDBC_VERSION="23.3.0.23.09" \
    ORACLE_JDBC_MD5=c6f402fe18e14e384f76ede75f8dc211

RUN docker-maven-download central "$ORACLE_JDBC_REPO" "$ORACLE_JDBC_GROUP" "$ORACLE_JDBC_VERSION" "$ORACLE_JDBC_MD5" || exit 1
USER kafka