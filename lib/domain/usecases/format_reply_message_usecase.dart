import '../../core/utils/time_utils.dart';
import '../entities/busy_status.dart';

class FormatReplyMessageUseCase {
  /// Formats the template with {status}, {duration}, {return_time}, and {caller_name}
  String execute({
    required BusyStatus status,
    required DateTime callTime,
    String? callerName,
    bool isBangla = true,
  }) {
    final template = status.messageTemplate.trim().isNotEmpty
        ? status.messageTemplate
        : (isBangla
            ? 'আমি {status} এ আছি। {duration} মিনিট পর কল ব্যাক করব।'
            : 'I am currently in {status}. Will call back in {duration} minutes.');

    final currentMinutes = callTime.hour * 60 + callTime.minute;
    final remainingMinutes = TimeUtils.calculateRemainingMinutes(
      currentMinutes: currentMinutes,
      startMinutes: status.startMinutes,
      endMinutes: status.endMinutes,
    );

    // Format return time
    final returnTimeStr = TimeUtils.formatMinutesTo12Hour(
      status.endMinutes,
      isBangla: isBangla,
    );

    final durationStr = TimeUtils.formatDurationMinutes(
      remainingMinutes > 0 ? remainingMinutes : 15,
      isBangla: isBangla,
    );

    String message = template
        .replaceAll('{status}', status.title)
        .replaceAll('{duration}', durationStr)
        .replaceAll('{return_time}', returnTimeStr);

    if (callerName != null && callerName.isNotEmpty) {
      message = message.replaceAll('{caller_name}', callerName);
    } else {
      message = message.replaceAll('{caller_name}', '');
    }

    return message.trim();
  }
}

