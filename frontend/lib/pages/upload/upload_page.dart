import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/connectivity_status_bloc/connectivity_status_cubit.dart';
import '../../bloc/local_track_uploading_bloc/local_track_uploading_bloc.dart';
import 'upload_from_device.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localTrackUploadingBloc =
        BlocProvider.of<LocalTrackUploadingBloc>(context);

    return BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
      builder: (context, state) {
        if (state is NoConnectionState) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 40),
                SizedBox(height: 16),
                Text('Tracks uploading is not available in offline mode'),
              ],
            ),
          );
        }

        return UploadFromDevice(
          trackUploadingBloc: localTrackUploadingBloc,
          onCancelPressed: () {},
        );
      },
    );

    // final trackUploadingBloc = BlocProvider.of<TrackUploadingBloc>(context);
    // return ExtractFromYoutube(trackUploadingBloc: trackUploadingBloc);
  }
}
