import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../widgets/widgets.dart';
import '../../constants/ui.dart';
import '../../constants/strings.dart';
import '../../bloc/settings_bloc.dart';

class ThemeSeedColorTile extends StatelessWidget {
  const ThemeSeedColorTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final Widget child = ListTile(
          leading: const SettingsIcon(MdiIcons.eyedropperVariant),
          title: const Text(SettingsConstants.accentColorHeading),
          trailing: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state.accentColorSource == AccentColorSource.material3
                  ? Theme.of(context).colorScheme.primary
                  : state.accentColor,
            ),
            width: kdefaultColorCircleSize,
          ),
        );
        if (state.accentColorSource == AccentColorSource.material3) {
          return Opacity(opacity: kdefaultDisableOpacity, child: child);
        } else {
          return InkWell(
            onTap: () async {
              ColorSwatch? swatch = await showDialog(
                context: context,
                builder: (context) => MaterialDialog(
                  content: MaterialColorPicker(
                    allowShades: false,
                    selectedColor: state.accentColor,
                    spacing: kdefaultPadding * 3,
                    circleSize: kdefaultColorCircleSize * 1.5,
                    colors: themeChoiceColors,
                    elevation: 0,
                    onMainColorChange: (value) {
                      Navigator.pop(context, value);
                    },
                  ),
                ),
              );
              if (swatch == null) return;

              context.read<SettingsBloc>().add(
                  SettingsEventAccentColorChangeRequested(Color(swatch.value)));
            },
            child: child,
          );
        }
      },
    );
  }
}
