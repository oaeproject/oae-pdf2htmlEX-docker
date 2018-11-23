#
# Copyright 2018 Apereo Foundation (AF) Licensed under the
# Educational Community License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may
# obtain a copy of the License at
#
#     http://opensource.org/licenses/ECL-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing
# permissions and limitations under the License.
#

# Heavily based on:
# - https://hub.docker.com/r/bwits/pdf2htmlex-alpine
# - https://gist.github.com/Rockstar04/c77f9f46f15be7b156aaed9a34bb5188

FROM alpine:3.8

ENV REFRESHED_AT 20181123
ENV POPPLER_NAME "poppler-0.63.0"
ENV POPPLER_SOURCE "https://ftp.osuosl.org/pub/blfs/conglomeration/poppler/$POPPLER_NAME.tar.xz"
ENV FONTFORGE_SOURCE "https://github.com/fontforge/fontforge.git"
ENV PDF2HTMLEX_SOURCE "https://github.com/Rockstar04/pdf2htmlEX.git"
ENV HOME_PATH "/"

RUN apk --update --no-cache add \
		alpine-sdk \
		xz \
		pango-dev \
		m4 \
		libtool \
		perl \
		autoconf \
		automake \
		coreutils \
		python-dev \
		zlib-dev \
		freetype-dev \
		glib-dev \
		cmake \
		libxml2-dev \
		libpng \
		libjpeg-turbo-dev \
		python \
		freetype \
		glib \
		libintl \
		libxml2 \
		libltdl \
		cairo \
		pango

# Install poppler
RUN echo "Installing Poppler ..."
RUN wget "$POPPLER_SOURCE" \
    && tar -xvf "$POPPLER_NAME.tar.xz" \
    && cd "$POPPLER_NAME/" \
    && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_XPDF_HEADERS=ON -DENABLE_LIBOPENJPEG=none \
    && make \
    && make install \
		&& cp /usr/lib64/libpoppler* /usr/lib/ \
		&& cp -r /usr/lib64/pkgconfig/* /usr/lib/pkgconfig/

# Install fontforge
RUN echo "Installing fontforge libuninameslist ..."
RUN cd "$HOME_PATH" \
		&& git clone https://github.com/fontforge/libuninameslist.git \
    && cd libuninameslist \
		&& autoreconf -i \
		&& automake \
		&& ./configure \
		&& make \
		&& make install

# Install fontforge
RUN echo "Installing fontforge ..."
RUN cd "$HOME_PATH" \
	 	&& git clone --depth 1 --single-branch --branch 20170731 "$FONTFORGE_SOURCE" \
		&& cd fontforge/ \
		&& git checkout tags/20170731 \
		&& ./bootstrap \
		&& ./configure \
		&& make \
		&& make install

# Install pdf2htmlEX
RUN echo "Installing Pdf2htmlEx ..."
RUN cd "$HOME_PATH" \
		&& git clone --depth 1 "$PDF2HTMLEX_SOURCE" \
		&& cd pdf2htmlEX/ \
		&& cmake . \
		&& make \
		&& make install

# Cleaning up
RUN echo "Removing sources ..."
RUN cd "$HOME_PATH" && rm -rf "$POPPLER_NAME.tar.xz" \
	  && cd "$HOME_PATH" && rm -rf "$POPPLER_NAME/" \
	  && cd "$HOME_PATH" && rm -rf "libuninameslist" \
	  && cd "$HOME_PATH" && rm -rf "fontforge" \
	  && cd "$HOME_PATH" && rm -rf "pdf2htmlEX"

# Debug
RUN pdf2htmlEX -v
RUN pdftotext -v

CMD ["/usr/local/bin/pdf2htmlEX"]
