# RUN add-apt-repository ppa:beineri/opt-qt571-trusty
# RUN add-apt-repository ppa:levi-armstrong/qt-libraries-trusty
# RUN add-apt-repository ppa:levi-armstrong/ppa  

# RUN apt-get update && \
#     apt-get install -y \
#       qt57creator \
#       qt57creator-plugin-ros \
#       clang-format-3.6 \
#       dbus
RUN apt-get update
RUN apt-get install -y qtcreator
RUN apt-get install -y \
	clang-format-3.6 \
	dbus

### FONT
COPY .fonts/SourceCodePro+Powerline+AwesomeRegular+Docker.ttf /root/.fonts/SourceCodePro+Powerline+AwesomeRegular+Docker.ttf
RUN fc-cache fv

###
# RUN export uid=1000 gid=1000 && \
#     mkdir -p /$USER && \
#     echo "$USER:x:${uid}:${gid}:$USER,,,:/$USER:/bin/zsh" >> /etc/passwd && \
#     echo "$USER:x:${uid}:" >> /etc/group && \
#     echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
#     chmod 0440 /etc/sudoers.d/$USER && \
#         chown ${uid}:${gid} -R /$USER

### CONFIG
## Qt configs
COPY .config /root/.config


# url: http://www.torkwrench.com/2011/12/16/d-bus-library-appears-to-be-incorrectly-set-up-failed-to-read-machine-uuid-failed-to-open-varlibdbusmachine-id/
RUN dbus-uuidgen > /var/lib/dbus/machine-id

# COPY qtcreator-4.2.1 /root/qtcreator-4.2.1
COPY run.sh /launch_qtcreator.sh
RUN chmod +x /launch_qtcreator.sh

COPY entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

ENTRYPOINT ["/entry-point.sh"]
CMD ["/launch_qtcreator.sh"]
