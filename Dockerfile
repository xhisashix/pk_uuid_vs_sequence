FROM debian:latest

# Install MySQL server and client tools including mysqlslap
RUN apt-get update && \
	apt-get install -y default-mysql-server default-mysql-client && \
	rm -rf /var/lib/apt/lists/*

COPY benchmark.sh /benchmark.sh
RUN chmod +x /benchmark.sh

ENTRYPOINT ["/benchmark.sh"]