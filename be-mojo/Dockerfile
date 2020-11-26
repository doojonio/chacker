FROM perl:5.32

ADD cpanfile /cpanfile
RUN cpanm -n --installdeps /

WORKDIR /app
COPY . /app

ENTRYPOINT ["/app/script/chacker"]
