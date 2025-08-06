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

# --- Password Generation Step ---
# Generate a hashed password and store it in a temporary file.
# We'll use a simple password 'mysecretpass' for demonstration.
# IMPORTANT: For production, you should use a strong, unique plaintext password here.
# The `tee` command prints to stdout (build logs) and saves to a file.
RUN HASHED_PASSWORD=$(python3 -c "from notebook.auth import passwd; print(passwd('murliastu1'))") && \
    echo "GENERATED JUPYTERLAB HASHED PASSWORD: $HASHED_PASSWORD" && \
    echo "c.ServerApp.password = '$HASHED_PASSWORD'" >> /root/.jupyter/jupyter_lab_config.py

# Set other JupyterLab configuration:
# - c.ServerApp.port: Set to run on port 8080.
# - c.ServerApp.allow_root: Allow JupyterLab to run as root (necessary for some environments).
# - c.ServerApp.open_browser: Do not open a browser automatically.
# - c.ServerApp.ip: Listen on all interfaces.
RUN echo "c.ServerApp.port = 8080" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.allow_root = True" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.open_browser = False" >> /root/.jupyter/jupyter_lab_config.py && \
    echo "c.ServerApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_lab_config.py

# Expose port 8080
EXPOSE 8080

# Command to run JupyterLab when the container starts
CMD ["jupyter", "lab", "--allow-root", "--port=8080", "--no-browser", "--ip=0.0.0.0"]
