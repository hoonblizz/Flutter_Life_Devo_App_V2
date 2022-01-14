import 'package:flutter_life_devo_app_v2/data/providers/global_api.dart';
import 'package:flutter_life_devo_app_v2/models/life_devo_model.dart';

const baseUrlDev = "https://api.bclifedevo.com/";
const apiUrlGetLifeDevo = "user/lifeDevo/getLifeDevo";
const apiUrlCreateLifeDevo = "user/lifeDevo/createLifeDevo";
const apiUrlUpdateLifeDevo = "user/lifeDevo/updateLifeDevo";

class UserContentsAPIClient {
  static getLifeDevo(String skCollection) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlGetLifeDevo, {"skCollection": skCollection});
  }

  // 새로 만드는거라 여기에는 pk, sk collection 등 몇가지 데이터는 없다.
  static createLifeDevo(LifeDevo lifedevo) async {
    print('Life devo check before create: ${lifedevo.toJSON()}');
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlCreateLifeDevo, lifedevo.toJSON());
  }

  // static updateLifeDevo(String skCollection,
  //     [String? answer,
  //     String? answer2,
  //     String? answer3,
  //     String? meditation,
  //     String? note,
  //     List? shared]) async {
  //   Map param = {"skCollection": skCollection};

  //   // 하나씩 붙여주기
  //   if (answer != null) param["answer"] = answer;
  //   if (answer2 != null) param["answer2"] = answer2;
  //   if (answer3 != null) param["answer3"] = answer3;
  //   if (meditation != null) param["meditation"] = meditation;
  //   if (note != null) param["note"] = note;
  //   if (shared != null) param["shared"] = shared;

  //   return await GlobalAPIClient.postRequest(
  //       baseUrlDev + apiUrlUpdateLifeDevo, param);
  // }
  static updateLifeDevo(LifeDevo lifedevo) async {
    return await GlobalAPIClient.postRequest(
        baseUrlDev + apiUrlUpdateLifeDevo, lifedevo.toJSON());
  }
}
