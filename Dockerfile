FROM jupyter/base-notebook:python-3.9

USER root

# Modify user and directory
RUN userdel -f jovyan && \
    groupadd open && \
    useradd -m -s /bin/bash -g open open && \
    cp -r /home/jovyan/* /home/open/ && \
    mkdir /home/private && \
    chown -R open:open /home/private &&\
    chown -R open:open /home/open

# Set the password hash as an environment variable
# Replace 'your_hashed_password_here' with the actual hash
ENV JUPYTER_PASSWORD_HASH='argon2:$argon2id$v=19$m=10240,t=10,p=8$7F1vxYSm1p0W8gjicwVcjQ$nM00KHf35A48dhxzMZ3DNb8sP3HTYwAO3LoZcDO7LSY' 
RUN echo "c.NotebookApp.password = u'$JUPYTER_PASSWORD_HASH'" >> /home/open/.jupyter/jupyter_notebook_config.py && echo "Success" || echo "Failure"
RUN cat /home/open/.jupyter/jupyter_notebook_config.py || echo "File not found"

# Update Jupyter configurations to reflect the new home directory
#RUN sed -i 's/\/home\/jovyan/\/home\/open/g' /home/open/.jupyter/jupyter_notebook_config.py

RUN apt-get -y update
RUN apt-get -y install \
    git \
    build-essential

# Install from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/

# Switch back to the new 'open' user as the default user
USER open
WORKDIR /home/open
RUN pip install --quiet --no-cache-dir --requirement /tmp/requirements.txt

CMD ["jupyter", "lab"]