// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hxd/core/modules/login/LoginPage.dart';

typedef Widget GalleryDemoBuilder();

class GalleryItem {
  const GalleryItem({
    @required this.routeName,
    @required this.buildRoute,
  })
      : assert(routeName != null),
        assert(buildRoute != null);

  final String routeName;
  final Widget buildRoute;
}

List<GalleryItem> _buildGalleryItems() {
  // When editing this list, make sure you keep it in sync with
  // the list in ../../test_driver/transitions_perf_test.dart
  final List<GalleryItem> galleryItems = <GalleryItem>[
    // Demos
    new GalleryItem(
      routeName: LoginPage.routeName,
      buildRoute: new LoginPage(),
    ),
  ];

  // Keep Pesto around for its regression test value. It is not included
  // in (release builds) the performance tests.

  return galleryItems;
}

final List<GalleryItem> kAllGalleryItems = _buildGalleryItems();
