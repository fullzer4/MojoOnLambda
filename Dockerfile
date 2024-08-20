FROM public.ecr.aws/lambda/python:3.11

RUN yum update -y && \
    yum install -y gcc wget tar gzip zip xz

ENV INSTALL_DIR /opt/python
ENV TEMP_DIR /tmp

RUN mkdir -p $INSTALL_DIR

WORKDIR $TEMP_DIR

RUN wget https://dl.modular.com/public/installer/deb/debian/pool/any-version/main/m/mo/modular_0.9.2/modular-v0.9.2-amd64.deb -O modular.deb && \
    ar -vx modular.deb && \
    tar -xf data.tar -C $INSTALL_DIR && \
    rm -rf modular.deb

RUN wget https://ftp.debian.org/debian/pool/main/n/ncurses/libncurses6_6.4-4_amd64.deb -O libncurses.deb && \
    wget https://ftp.debian.org/debian/pool/main/libe/libedit/libedit2_3.1-20221030-2_amd64.deb -O libedit.deb && \
    ar -vx libncurses.deb && \
    tar -xf data.tar.xz -C $INSTALL_DIR && \
    ar -vx libedit.deb && \
    tar -xf data.tar.xz -C $INSTALL_DIR && \
    rm -rf libncurses.deb libedit.deb

RUN ln -sf $INSTALL_DIR/lib/x86_64-linux-gnu/libncurses.so.6.4 $INSTALL_DIR/lib/x86_64-linux-gnu/libncurses.so.6 && \
    ln -sf $INSTALL_DIR/usr/lib/x86_64-linux-gnu/libform.so.6.4 $INSTALL_DIR/usr/lib/x86_64-linux-gnu/libform.so.6 && \
    ln -sf $INSTALL_DIR/usr/lib/x86_64-linux-gnu/libpanel.so.6.4 $INSTALL_DIR/usr/lib/x86_64-linux-gnu/libpanel.so.6 && \
    ln -sf $INSTALL_DIR/usr/lib/x86_64-linux-gnu/libedit.so.2.0.70 $INSTALL_DIR/usr/lib/x86_64-linux-gnu/libedit.so.2

ENV LD_LIBRARY_PATH=$INSTALL_DIR/lib/x86_64-linux-gnu:$INSTALL_DIR/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
ENV PATH=$INSTALL_DIR/.modular/pkg/packages.modular.com_mojo/bin:$PATH
