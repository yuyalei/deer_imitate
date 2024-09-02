import 'package:azlistview/azlistview.dart';

import '../../generated/json/bank_entity.g.dart';
import '../../generated/json/base/json_field.dart';

@JsonSerializable()
class BankEntity with ISuspensionBean {

	BankEntity({this.id, this.bankName, this.firstLetter});

	factory BankEntity.fromJson(Map<String, dynamic> json) => $BankEntityFromJson(json);

	Map<String, dynamic> toJson() => $BankEntityToJson(this);

	int? id;
	String? bankName;
	String? firstLetter;

	@override
  String getSuspensionTag() {
		return firstLetter ?? '';
  }
}
