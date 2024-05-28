class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final String? image; // Cambiado a nullable

  final Map<String, dynamic>? data;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    this.image, // Cambiado a nullable
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'title': title,
      'body': body,
      'sentDate': sentDate.toString(),
      'imageUrl':
          image ?? '', // Usa imageUrl o un valor predeterminado si es nulo
      'data': data,
    };
  }

  @override
  String toString() {
    return '''
      PushMessage -
      messageId: $messageId
      title: $title
      body: $body
      sentDate: $sentDate
      data: $data
      imageUrl: $image
    ''';
  }
}
