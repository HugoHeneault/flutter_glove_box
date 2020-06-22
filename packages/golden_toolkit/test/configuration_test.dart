/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
///

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('GoldenToolkitConfiguration Tests', () {
    testGoldens('screenMatchesGolden method should defer skip to global configuration', (tester) async {
      GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => true));
      await tester.pumpWidget(Container());
      await screenMatchesGolden(tester, 'this_is_expected_to_skip');
    });

    testGoldens('screenMatchesGolden method level skip should trump global configuration', (tester) async {
      GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => false));
      await tester.pumpWidgetBuilder(Container());
      await screenMatchesGolden(tester, 'this_is_expected_to_skip', skip: true);
    });

    testGoldens('MultiScreenGolden method should defer skip to global configuration', (tester) async {
      GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => true));
      await tester.pumpWidgetBuilder(Container());
      await multiScreenGolden(tester, 'this_is_expected_to_skip');
    });

    testGoldens('MultiScreenGolden method level skip should trump global configuration', (tester) async {
      GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => false));
      await tester.pumpWidgetBuilder(Container());
      await multiScreenGolden(tester, 'this_is_expected_to_skip', skip: true);
    });

    testGoldens('screenMatchesGolden method should defer fileNameFactory to global configuration', (tester) async {
      GoldenToolkit.configure(
        GoldenToolkitConfiguration(fileNameFactory: (name) => 'goldens/custom/custom_$name.png'),
      );
      await tester.pumpWidgetBuilder(Container());
      await screenMatchesGolden(tester, 'global_file_name_factory');
    });

    testGoldens('multiScreenGolden method should defer fileNameFactory to global configuration', (tester) async {
      GoldenToolkit.configure(
        GoldenToolkitConfiguration(
            deviceFileNameFactory: (name, device) => 'goldens/custom/custom_${name}_${device.name}.png'),
      );
      await tester.pumpWidgetBuilder(Container());
      await multiScreenGolden(tester, 'global_device_file_name_factory');
    });

    test('Default Configuration', () {
      const config = GoldenToolkitConfiguration();
      expect(config.skipGoldenAssertion(), isFalse);
      expect(config.fileNameFactory('test_name'), equals('goldens/test_name.png'));
      expect(
        config.deviceFileNameFactory('test_name', const Device(name: 'my_device', size: Size(500, 500))),
        equals('goldens/test_name.my_device.png'),
      );
    });
  });
}