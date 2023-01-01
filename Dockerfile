FROM node:18-alpine AS build

RUN apk update
RUN apk add --no-cache --quiet git

RUN corepack enable

RUN mkdir -p /root/.config/dmx-hue-nodejs/

RUN git config --global advice.detachedHead false

WORKDIR /build/

RUN git clone -b 1.4.2 --depth 1 https://github.com/sinedied/dmx-hue.git

WORKDIR /build/dmx-hue/

COPY ./config.sample.json config.json

RUN pnpm install

FROM node:18-alpine

RUN mkdir -p /root/.config/dmx-hue-nodejs/

COPY --from=build /build/dmx-hue/ /opt/dmx-hue/

WORKDIR /opt/dmx-hue/

CMD ["/opt/dmx-hue/bin/dmx-hue"]

EXPOSE 6454

