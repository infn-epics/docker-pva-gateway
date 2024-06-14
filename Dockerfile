FROM baltig.infn.it:4567/epics-containers/epics-py-base AS base
USER root
RUN pip install --upgrade p4p nose2
USER epics
CMD ["python", "-m", "p4p.gw"]

