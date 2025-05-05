import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/repository/post_firebase_repository.dart';
import 'package:widget_testing/view/post/firestore_crud/create_post_f.dart';

// In unit tests we mock FirebaseFirestore (collections, docs, queries) to verify repository logic; in widget tests we mock the repository itself to focus solely on UI behavior.
class MockPostFirebaseRespository extends Mock
    implements PostFirebaseRepository {}

class FakePost extends Fake implements Post {}

late MockPostFirebaseRespository mockPostFirebaseRespository;
void main() {
  setUpAll(() {
    registerFallbackValue(FakePost());
  });
  setUp(() {
    mockPostFirebaseRespository = MockPostFirebaseRespository();
  });

  testWidgets("Post Firebase", (tester) async {
    when(() => mockPostFirebaseRespository.isLoading).thenReturn(false);
    when(() => mockPostFirebaseRespository.setPost(any(), any()))
        .thenAnswer((ans) async {
      return "Post Created";
    });

    await tester.pumpWidget(MaterialApp(
      home:
          CreatePostFView(postFirebaseRepository: mockPostFirebaseRespository),
    ));

    final titleTextField = find.byKey(const Key("postTextFormField"));
    final bodyTextField = find.byKey(const Key("bodyTextFormField"));

    await tester.enterText(titleTextField, "Title");
    await tester.enterText(bodyTextField, "Body");
    final btn = find.byType(ElevatedButton);
    await tester.tap(btn);

    await tester.pump();

    expect(find.text("Post Created"), findsOneWidget);
  });
}
