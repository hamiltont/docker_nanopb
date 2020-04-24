FROM i386/ubuntu:18.04 as builder

ARG version=0.4.1
ENV nanopbVersion=nanopb-${version}-linux-x86
ENV nanopbFile=${nanopbVersion}.tar.gz


WORKDIR /opt
RUN apt-get update && apt-get install -y python curl nano bash
RUN curl -O https://jpa.kapsi.fi/nanopb/download/${nanopbFile} && tar -xzf ${nanopbFile}
RUN mkdir generator && cp -a ${nanopbVersion}/. nanopb
# Save ~2MB (Final image will not have test suite dependencies)
RUN rm -rf nanopb/tests



FROM i386/ubuntu:18.04 as generator
RUN apt-get update && apt-get install -y \
    git-core \
    && rm -rf /var/lib/apt/lists/*```
WORKDIR /app
COPY --from=builder /opt/nanopb /opt/nanopb
ENV PATH="/opt/nanopb/generator-bin:${PATH}"
