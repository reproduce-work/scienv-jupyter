FROM quay.io/jupyter/base-notebook:python-3.11

USER root

RUN apt-get -y update
RUN apt-get -y install \
    git \
    build-essential

# Install from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/

USER ${NB_USER}
WORKDIR /home/jovyan
RUN pip install --quiet --no-cache-dir --requirement /tmp/requirements.txt

CMD ["jupyter", "lab"]