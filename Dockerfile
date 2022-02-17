FROM quay.io/pypa/manylinux2014_x86_64

RUN yum update
RUN yum install -y openssl-devel libffi-devel

RUN curl https://www.python.org/ftp/python/3.9.7/Python-3.9.7.tgz > Python-3.9.7.tgz \
    && tar xzf Python-3.9.7.tgz \
    && cd Python-3.9.7 \
    && ./configure \
    && make altinstall \
    && cd .. \
    && rm -r Python-3.9.7 Python-3.9.7.tgz

RUN curl https://zlib.net/fossils/zlib-1.2.8.tar.gz > zlib-1.2.8.tar.gz \
    && tar xzf zlib-1.2.8.tar.gz \
    && cd zlib-1.2.8 \
    && ./configure \
    && make -j4 \
    && make install \
    && cd .. \
    && rm -r zlib-1.2.8 zlib-1.2.8.tar.gz

RUN curl -L https://download.sourceforge.net/libjpeg-turbo/libjpeg-turbo-2.1.2.tar.gz > libjpeg-turbo-2.1.2.tar.gz \
    && tar xzf libjpeg-turbo-2.1.2.tar.gz \
    && cd libjpeg-turbo-2.1.2 \
    && cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=/usr/local/lib . \
    && make install \
    && cd .. \
    && rm -r libjpeg-turbo-2.1.2 libjpeg-turbo-2.1.2.tar.gz

RUN curl -L https://tukaani.org/xz/xz-5.2.5.tar.gz > xz-5.2.5.tar.gz \
    && tar xzf xz-5.2.5.tar.gz \
    && cd xz-5.2.5 \
    && ./configure \
    && make -j4 \
    && make install \
    && cd .. \
    && rm -r xz-5.2.5 xz-5.2.5.tar.gz

RUN curl -L https://download.osgeo.org/libtiff/tiff-4.3.0.tar.gz > tiff-4.3.0.tar.gz \
    && tar xzf tiff-4.3.0.tar.gz \
    && cd tiff-4.3.0 \
    && ./configure \
    && make -j4 \
    && make install \
    && cd .. \
    && rm -r tiff-4.3.0 tiff-4.3.0.tar.gz

RUN python3.9 -m pip install --upgrade pip wheel auditwheel \
    && git clone https://github.com/python-pillow/Pillow \
    && cd Pillow \
    && python3.9 setup.py bdist_wheel \
    && cd .. \
    && python3.9 -m auditwheel repair Pillow/dist/Pillow-9.1.0.dev0-cp39-cp39-linux_x86_64.whl

RUN python3.9 -m pip install /wheelhouse/Pillow-9.1.0.dev0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl \
    && find /usr/local/lib/python3.9/site-packages -name '*.so*' | xargs ldd
