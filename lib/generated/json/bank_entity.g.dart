
import 'package:azlistview/azlistview.dart';

import '../../account/models/bank_entity.dart';
import 'base/json_convert_content.dart';


BankEntity $BankEntityFromJson(Map<String, dynamic> json) {
	final BankEntity bankEntity = BankEntity();
	final int? id = jsonConvert.convert<int>(json['id']);
	if (id != null) {
		bankEntity.id = id;
	}
	final String? bankName = jsonConvert.convert<String>(json['bankName']);
	if (bankName != null) {
		bankEntity.bankName = bankName;
	}
	final String? firstLetter = jsonConvert.convert<String>(json['firstLetter']);
	if (firstLetter != null) {
		bankEntity.firstLetter = firstLetter;
	}
	return bankEntity;
}

Map<String, dynamic> $BankEntityToJson(BankEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['bankName'] = entity.bankName;
	data['firstLetter'] = entity.firstLetter;
	return data;
}