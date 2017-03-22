RUN wget \
	https://download.jetbrains.com/python/pycharm-community-2016.3.3.tar.gz	\
	-O /pycharm-community-2016.3.3.tar.gz
RUN tar xzvf /pycharm-community-2016.3.3.tar.gz

COPY run.sh /launch_pycharm.sh
RUN chmod +x /launch_pycharm.sh

COPY entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

ENTRYPOINT ["/entry-point.sh"]
CMD ["/launch_pycharm.sh"]