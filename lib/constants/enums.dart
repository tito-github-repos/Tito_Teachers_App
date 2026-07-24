enum UserRole {
  teacher,
  student,
}

enum PaymentStatus {
  pending,
  paid,
  overdue,
}

enum PaymentMode {
  cash,
  upi,
  bank,
  cheque,
}

extension PaymentStatusExtension on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return "Pending";
      case PaymentStatus.paid:
        return "Paid";
      case PaymentStatus.overdue:
        return "Overdue";
    }
  }

  static PaymentStatus fromString(String value) {
    switch (value) {
      case "Paid":
        return PaymentStatus.paid;
      case "Overdue":
        return PaymentStatus.overdue;
      default:
        return PaymentStatus.pending;
    }
  }
}

extension PaymentModeExtension on PaymentMode {
  String get value {
    switch (this) {
      case PaymentMode.cash:
        return "Cash";
      case PaymentMode.upi:
        return "UPI";
      case PaymentMode.bank:
        return "Bank";
      case PaymentMode.cheque:
        return "Cheque";
    }
  }

  static PaymentMode fromString(String value) {
    switch (value) {
      case "UPI":
        return PaymentMode.upi;
      case "Bank":
        return PaymentMode.bank;
      case "Cheque":
        return PaymentMode.cheque;
      default:
        return PaymentMode.cash;
    }
  }
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.teacher:
        return "teacher";
      case UserRole.student:
        return "student";
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case "student":
        return UserRole.student;
      default:
        return UserRole.teacher;
    }
  }
}