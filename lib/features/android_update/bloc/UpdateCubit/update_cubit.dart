import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:panel_image_uploader/features/auth/data/auth_remote_data_source.dart';
import 'package:panel_image_uploader/my_app.dart';
import 'package:pub_semver/pub_semver.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  final AuthRemoteDataSource ds;
  UpdateCubit(this.ds) : super(UpdateInitial());

  checkUpdate() async {
    emit(UpdateInitial());
    var failOrNot = await ds.getServerVersion();
    failOrNot.fold((l) {}, (r) {
      final remoteVersion = Version.parse(r['version']);
      final localVersion = Version.parse(version);
      if (remoteVersion > localVersion) {
        var lastVersion = LastVersion.fromJson(r);
        emit(NeedUpdate(lastVersion: lastVersion));
      } else {
        emit(UpToDate());
      }
    });
  }
}

class LastVersion {
  String? version;
  String? fileName;
  String? updateInfo;
  DateTime? createdAt;

  LastVersion({this.version, this.fileName, this.updateInfo, this.createdAt});

  factory LastVersion.fromJson(Map<String, dynamic> json) {
    return LastVersion(
      version: json["version"],
      fileName: json["fileName"],
      updateInfo: json["updateInfo"],
      createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    );
  }
}
