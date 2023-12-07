# Use a base image with Java
FROM openjdk:11-slim

RUN apt-get update && apt-get install -y python3 python3-pip git

# Download and install the complexity tool
ADD https://github.com/thoughtbot/complexity/releases/download/0.4.2/complexity-0.4.2-x86_64-unknown-linux-musl.tar.gz /tmp/
RUN tar -xzf /tmp/complexity-0.4.2-x86_64-unknown-linux-musl.tar.gz -C /tmp/
RUN mv /tmp/complexity-0.4.2-x86_64-unknown-linux-musl/complexity /usr/local/bin/complexity

RUN complexity install-configuration

COPY code-maat-1.0.4-standalone.jar /usr/local/bin/code-maat-1.0.4-standalone.jar

# Copy analysis script and the entrypoint script into the image
COPY churn_vs_complexity.sh /usr/local/bin/churn_vs_complexity.sh
COPY coupling.sh /usr/local/bin/coupling.sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /usr/local/bin/churn_vs_complexity.sh
RUN chmod +x /usr/local/bin/coupling.sh
RUN chmod +x /entrypoint.sh


# Create a directory for the web server content and analysis
WORKDIR /var/www
COPY index.html /var/www/index.html

# For the web server
EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
