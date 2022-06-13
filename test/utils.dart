import 'package:altogic_dart/altogic_dart.dart';
import 'package:altogic_dart_test/utils.dart';
import 'package:test/expect.dart';

SuccessResponseMatcher successResponse = SuccessResponseMatcher(true);
SuccessResponseMatcher errorResponse = SuccessResponseMatcher(false);

class SuccessResponseMatcher extends Matcher {
  SuccessResponseMatcher(this.success);

  bool success;

  @override
  Description describe(Description description) {
    return description..add(success ? 'Success Response' : 'Error Response');
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    return mismatchDescription
      ..add('Error: '
          '${item is APIError ? item : item is APIResponseBase ? item.errors : null} '
          '\nData: '
          '${item is APIError ? null : item is APIResponseBase ? item.getData() : null}');
  }

  @override
  bool matches(item, Map<dynamic, dynamic> matchState) {
    if (item is APIResponse) {
      var data = item.getData();
      return success
          ? item.errors == null && data != null
          : item.errors != null;
    } else if (item == null || item is APIError) {
      return success ? item == null : item != null;
    } else {
      return false;
    }
  }
}
