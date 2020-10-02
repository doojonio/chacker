FROM perl:5.32

ADD cpanfile /cpanfile
RUN HARNESS_OPTIONS=j4 cpanm --installdeps /

WORKDIR /app
COPY . /app

ENTRYPOINT ["/app/script/chacker"]
