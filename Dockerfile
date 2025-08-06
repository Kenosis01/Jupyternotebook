# Use the latest Ubuntu base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update apt and install Python 3, pip, and build dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-pip build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install JupyterLab using --break-system-packages to avoid PEP 668 errors
RUN pip3 install --break-system-packages jupyterlab

# Generate a Jupyter configuration file
RUN jupyter lab --generate-config

# Set JupyterLab configuration:
# - c.ServerApp.password: Placeholder for the hashed password.
#   IMPORTANT: Replace 'sha1:YOUR_HASHED_PASSWORD_HERE' with your actual hashed password.
#   You can generate a hashed password by running `from notebook.auth import passwd; passwd()` in a Python console.
# - c.ServerApp.port: Set to run on port 8080.
# - c.ServerApp.allow_root: Allow JupyterLab to run as root (necessary for some environments).
# - c.ServerApp.open_browser: Do not open a browser automatically.
RUN echo "c.ServerApp.password = 'sha1:murliastu1'" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.port = 8080" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.open_browser = False" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_lab_config.py

# Expose port 8080
EXPOSE 8080

# Command to run JupyterLab when the container starts
CMD ["jupyter", "lab", "--allow-root", "--port=8080", "--no-browser", "--ip=0.0.0.0"]
