FROM baltig.infn.it:4567/epics-containers/epics-py-base AS base
USER root
RUN pip install --upgrade p4p nose2
ARG USER_ID=epics
ARG USER_UID=1000
ARG GROUP_ID=control
ARG GROUP_UID=1000


RUN chown -R ${USER_UID}:${GROUP_UID} /epics
USER ${USER_ID}
CMD ["python", "-m", "nose2","p4p"]

