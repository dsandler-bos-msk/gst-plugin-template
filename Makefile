################################################################################
# Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
################################################################################

TARGET_NAME:= libgst__PLUGINNAME__.so

include config.mk

PLUGIN_INSTALL_DIR?=$(shell pkg-config --variable=pluginsdir gstreamer-1.0 )

SOURCE_FILES:=	$(wildcard *.c)
HEADER_FILES:= $(wildcard *.h)

OBJECT_FILES:= $(SOURCE_FILES:.c=.o)

CFLAGS:= $(shell pkg-config --cflags gstreamer-1.0)
CFLAGS+= -fPIC -I. -g

LDFLAGS:= $(shell pkg-config --libs gstreamer-1.0)
LDFLAGS+= -shared -Wl,-export-dynamic 

all: $(TARGET_NAME)

config.h:
	@echo "#"define PACKAGE_VERSION \"$(PACKAGE_VERSION)\" > config.h
	@echo "#"define PACKAGE \"$(PACKAGE)\" >> config.h
	@echo "#"define GST_LICENSE \"$(GST_LICENSE)\" >> config.h
	@echo "#"define GST_API_VERSION \"$(GST_API_VERSION)\" >> config.h
	@echo "#"define GST_PACKAGE_NAME \"$(GST_PACKAGE_NAME)\" >> config.h
	@echo "#"define GST_PACKAGE_ORIGIN \"$(GST_PACKAGE_ORIGIN)\" >> config.h

%.o: %.c $(HEADER_FILES) config.h Makefile 
	@$(CC) -c -o $@ $(CFLAGS) $<

$(TARGET_NAME): $(OBJECT_FILES) Makefile
	@$(CC) -o $(TARGET_NAME) $(OBJECT_FILES) $(LDFLAGS)

install: $(TARGET_NAME)
	@cp -rv $(TARGET_NAME) $(PLUGIN_INSTALL_DIR)

clean:
	@rm -rf $(OBJECT_FILES) $(TARGET_NAME) config.h
