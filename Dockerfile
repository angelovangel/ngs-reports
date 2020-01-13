FROM rocker/rstudio:3.6.1
LABEL authors="aangeloo@gmail.com" \
      description="Docker image containing all requirements for the ngs-reports pipeline"

COPY environment.yml /
COPY bin /bin
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/ngs-reports-0.1/bin:$PATH
