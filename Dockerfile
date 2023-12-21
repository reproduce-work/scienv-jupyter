FROM quay.io/jupyter/base-notebook:python-3.11

USER root

# Update and install dependencies
RUN apt-get -y update \
    && apt-get -y install git

# Copy requirements.txt and install Python packages
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/
RUN pip install --quiet --no-cache-dir --requirement /tmp/requirements.txt

USER ${NB_USER}

# Disable the JupyterLab extension
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# Set the working directory
WORKDIR /home/jovyan

# Default command to run on container start
CMD ["jupyter", "lab", "--NotebookApp.allow_origin_pat=http://localhost:(.+)"]
