FROM tatemz/wp-cli
RUN apt update && \
    apt upgrade -y && \
    apt install patch
COPY wp-ami-setup.sh /home/
COPY qtranslate_options.patch /home/
COPY custom-post-types-import.php /home/
COPY default-content.xml /home/
COPY cors.php /home/