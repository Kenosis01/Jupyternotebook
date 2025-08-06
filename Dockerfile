# Use the latest Ubuntu image
FROM ubuntu:latest

# Install Python, pip, and other dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev

# Set working directory
WORKDIR /app

# Install JupyterLab
RUN pip3 install jupyterlab

# Generate Jupyter config with password
RUN jupyter lab --generate-config && \
    echo "c.NotebookApp.password = u'murliastu1'" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.NotebookApp.port = 1000" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_lab_config.py

# Expose the port
EXPOSE 10000

# Start JupyterLab
CMD ["jupyter", "lab"]
