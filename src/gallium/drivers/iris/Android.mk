# Mesa 3-D graphics library
#
# Copyright (C) 2018 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

LOCAL_PATH := $(call my-dir)

# get C_SOURCES
include $(LOCAL_PATH)/Makefile.sources

include $(CLEAR_VARS)

LIBIRIS_SRC_FILES := \
	iris_blorp.c \
	iris_state.c

LIBIRIS_STATIC_LIBS := \
	libmesa_nir

IRIS_COMMON_INCLUDES := \
	$(MESA_TOP)/src/mapi \
	$(MESA_TOP)/src/mesa \
	$(MESA_TOP)/src/gallium/include \
	$(MESA_TOP)/src/gallium/auxiliary

#
# libiris for gen8
#

include $(CLEAR_VARS)
LOCAL_MODULE := libmesa_iris_gen8
LOCAL_MODULE_CLASS := STATIC_LIBRARIES

LOCAL_SRC_FILES := $(LIBIRIS_SRC_FILES)
LOCAL_CFLAGS := -DGEN_VERSIONx10=80

LOCAL_C_INCLUDES := $(IRIS_COMMON_INCLUDES)

LOCAL_STATIC_LIBRARIES := $(LIBIRIS_STATIC_LIBS)

LOCAL_HEADER_LIBRARIES := libmesa_genxml

include $(MESA_COMMON_MK)
include $(BUILD_STATIC_LIBRARY)

#
# libiris for gen9
#

include $(CLEAR_VARS)
LOCAL_MODULE := libmesa_iris_gen9
LOCAL_MODULE_CLASS := STATIC_LIBRARIES

LOCAL_SRC_FILES := $(LIBIRIS_SRC_FILES)
LOCAL_CFLAGS := -DGEN_VERSIONx10=90

LOCAL_C_INCLUDES := $(IRIS_COMMON_INCLUDES)

LOCAL_STATIC_LIBRARIES := $(LIBIRIS_STATIC_LIBS)

LOCAL_HEADER_LIBRARIES := libmesa_genxml

include $(MESA_COMMON_MK)
include $(BUILD_STATIC_LIBRARY)

#
# libiris for gen10
#

include $(CLEAR_VARS)
LOCAL_MODULE := libmesa_iris_gen10
LOCAL_MODULE_CLASS := STATIC_LIBRARIES

LOCAL_SRC_FILES := $(LIBIRIS_SRC_FILES)
LOCAL_CFLAGS := -DGEN_VERSIONx10=100

LOCAL_C_INCLUDES := $(IRIS_COMMON_INCLUDES)

LOCAL_STATIC_LIBRARIES := $(LIBIRIS_STATIC_LIBS)

LOCAL_HEADER_LIBRARIES := libmesa_genxml

include $(MESA_COMMON_MK)
include $(BUILD_STATIC_LIBRARY)

#
# libiris for gen11
#

include $(CLEAR_VARS)
LOCAL_MODULE := libmesa_iris_gen11
LOCAL_MODULE_CLASS := STATIC_LIBRARIES

LOCAL_SRC_FILES := $(LIBIRIS_SRC_FILES)
LOCAL_CFLAGS := -DGEN_VERSIONx10=110

LOCAL_C_INCLUDES := $(IRIS_COMMON_INCLUDES)

LOCAL_STATIC_LIBRARIES := $(LIBIRIS_STATIC_LIBS)

LOCAL_HEADER_LIBRARIES := libmesa_genxml

include $(MESA_COMMON_MK)
include $(BUILD_STATIC_LIBRARY)


###########################################################
include $(CLEAR_VARS)

LOCAL_MODULE := libmesa_pipe_iris
LOCAL_MODULE_CLASS := STATIC_LIBRARIES

intermediates := $(call local-generated-sources-dir)
prebuilt_intermediates := $(MESA_TOP)/prebuilt-intermediates

LOCAL_GENERATED_SOURCES := $(addprefix $(intermediates)/iris/,$(GENERATED_SOURCES))

GEN_DRIINFO_INPUTS := \
        $(MESA_TOP)/src/gallium/auxiliary/pipe-loader/driinfo_gallium.h \
        $(LOCAL_PATH)/driinfo_iris.h

MERGE_DRIINFO := $(MESA_TOP)/src/util/merge_driinfo.py

$(intermediates)/iris/iris_driinfo.h: $(prebuilt_intermediates)/iris/iris_driinfo.h
	@mkdir -p $(dir $@)
	@cp -f $< $@

LOCAL_EXPORT_C_INCLUDE_DIRS := $(intermediates)

LOCAL_SRC_FILES := \
	$(IRIS_C_SOURCES)

LOCAL_C_INCLUDES := \
	$(MESA_TOP)/src/mapi \
	$(MESA_TOP)/src/mesa \
	$(MESA_TOP)/include/drm-uapi \
	$(MESA_TOP)/src/gallium/include

LOCAL_SHARED_LIBRARIES := libdrm_intel

LOCAL_STATIC_LIBRARIES := \
	libmesa_intel_common \
	libmesa_nir

LOCAL_HEADER_LIBRARIES := \
	libmesa_genxml

LOCAL_WHOLE_STATIC_LIBRARIES := \
	libmesa_blorp \
	libmesa_intel_common \
	libmesa_intel_compiler \
	libmesa_iris_gen8 \
	libmesa_iris_gen9 \
	libmesa_iris_gen10 \
	libmesa_iris_gen11

include $(GALLIUM_COMMON_MK)
include $(BUILD_STATIC_LIBRARY)

ifneq ($(HAVE_GALLIUM_IRIS),)
GALLIUM_TARGET_DRIVERS += iris
$(eval GALLIUM_LIBS += $(LOCAL_MODULE) libmesa_winsys_iris)
$(eval GALLIUM_SHARED_LIBS += $(LOCAL_SHARED_LIBRARIES))
endif
