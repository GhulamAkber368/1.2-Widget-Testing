import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widget_testing/model/post.dart';
import 'package:widget_testing/repository/post_firebase_repository.dart';
import 'package:widget_testing/repository/post_repository.dart';
import 'package:widget_testing/view/post/firestore_crud/create_post_f_view.dart';
import 'package:widget_testing/view/post/firestore_crud/delete_post_f_view.dart';
import 'package:widget_testing/view/post/firestore_crud/get_post_f_view.dart';
import 'package:widget_testing/view/post/firestore_crud/get_posts_f_view.dart';
import 'package:widget_testing/view/post/firestore_crud/update_post_f_view.dart';

// In unit tests we mock FirebaseFirestore (collections, docs, queries) to verify repository logic; in widget tests we mock the repository itself to focus solely on UI behavior.
// We're injecting a mock repository, so real FirebaseFirestore is never used.
// The mock overrides methods like setPost, so no actual Firestore code runs during tests.

class MockPostFirebaseRespository extends Mock
    implements PostFirebaseRepository {}

class FakePost extends Fake implements Post {}

late MockPostFirebaseRespository mockPostFirebaseRespository;
void main() {
// What it does: Runs once before all tests.
// Why registerFallbackValue: It tells mocktail “If you see any<Post>(), you can use this FakePost() instance under the hood.” Without this, matching Post arguments would crash due to null-safety.
// In simple terms: We register our dummy Post so our mocks can accept any Post without blowing up.
  setUpAll(() {
    registerFallbackValue(FakePost());
  });
  setUp(() {
    mockPostFirebaseRespository = MockPostFirebaseRespository();
  });

  group("Set Post", () {
    testWidgets(
        "given Post Firebase Repository Class when setPost Func is called and Post is created then Post Created message should be display",
        (tester) async {
      // We're returning isLoading = false in the test stub because in your UI code, this line controls whether the loading spinner shows or not:
      // If we don't return false, it might default to null, which causes a type error or shows the wrong widget.
      // Same for isLoading to true
      // As we are mocking therefore isLoading of PostFirebaseRepository will also never use. Therefore we are using new isLoadingTest variable here and returning new isLoadingTest whenever we need isLoading.

      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      when(() => mockPostFirebaseRespository.setPost(any(), any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Post Created";
      });

      await tester.pumpWidget(MaterialApp(
        home: CreatePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final titleTextField = find.byKey(const Key("postTextFormField"));
      final bodyTextField = find.byKey(const Key("bodyTextFormField"));

      await tester.enterText(titleTextField, "Title");
      await tester.enterText(bodyTextField, "Body");

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Post Created"), findsOneWidget);
    });

    testWidgets(
        "given Post Repository Class when setPost Func is called and Firebase Exception occur then Firebase Exception message should be display.",
        (tester) async {
      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      // As this is Widget Testing, Therefore we are returing String "Firebase Exception" not the Exception. Exception cases should be tested in Unit Tests.
      // Becuase here we are returning FirebaseException and in Func on Firebase exception we are returning String but as we are mocking so FirebaseException portion of Func will never be execute therefore we have to send Firestore Exception here directly.
      when(() => mockPostFirebaseRespository.setPost(any(), any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Firebase Exception";
        // throw FirebaseException(
        //   plugin: 'firestore',
        // );
      });

      await tester.pumpWidget(MaterialApp(
        home: CreatePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final titleTextField = find.byKey(const Key("postTextFormField"));
      final bodyTextField = find.byKey(const Key("bodyTextFormField"));

      await tester.enterText(titleTextField, "Title");
      await tester.enterText(bodyTextField, "Body");

      expect(find.text("Title"), findsOneWidget);

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Firebase Exception"), findsOneWidget);
    });

    testWidgets(
        "given Post Repository Class when setPost Func is called and Exception occur then \"Exception\" message should be display.",
        (tester) async {
      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      // As this is Widget Testing, Therefore we are returing String "Firebase Exception" not the Exception. Exception cases should be tested in Unit Tests.
      when(() => mockPostFirebaseRespository.setPost(any(), any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Exception";
      });

      await tester.pumpWidget(MaterialApp(
        home: CreatePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final titleTextField = find.byKey(const Key("postTextFormField"));
      final bodyTextField = find.byKey(const Key("bodyTextFormField"));

      await tester.enterText(titleTextField, "Title");
      await tester.enterText(bodyTextField, "Body");

      expect(find.text("Title"), findsOneWidget);

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Exception"), findsOneWidget);
    });
  });

  group("Get Post", () {
    testWidgets(
        "given Post Firebase Repository Class when Get Post Func is called then Title and Body should be display on Screen",
        (tester) async {
      when(() => mockPostFirebaseRespository.getPost(any()))
          .thenAnswer((ans) async {
        // As we are using FutureBuilder in UI therefore we dont need to use Future.delay here because FutureBuilder will await by itself.
        // Future.delayed(const Duration(milliseconds: 100));
        return Post(title: "Post Title", body: "Post Body");
      });

      await tester.pumpWidget(MaterialApp(
        home: GetPostFView(postFirebaseRepository: mockPostFirebaseRespository),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Title: Post Title"), findsOneWidget);
      expect(find.text("Body: Post Body"), findsOneWidget);
    });

    testWidgets(
        "given Post Firebase Repository Class when getPost Func is called and firebase exception occur then Something went Wrong message should be display.",
        (tester) async {
      when(() => mockPostFirebaseRespository.getPost(any()))
          // We cant use here thenThrow directly because we are using FutureBuilder in UI therefore we have to use asyns here using thenAnswer
          .thenAnswer((ans) async {
        throw FirebaseException(
          plugin: 'firestore',
        );
      });

      await tester.pumpWidget(MaterialApp(
        home: GetPostFView(postFirebaseRepository: mockPostFirebaseRespository),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Something went Wrong"), findsOneWidget);
    });

    testWidgets(
        "given Post Firebase Repository Class when getPost Func is called and general exception occur then Something went Wrong message should be display.",
        (tester) async {
      when(() => mockPostFirebaseRespository.getPost(any()))
          // We cant use here thenThrow directly because we are using FutureBuilder in UI therefore we have to use asyns here using thenAnswer
          .thenAnswer((ans) async {
        throw Exception();
      });

      await tester.pumpWidget(MaterialApp(
        home: GetPostFView(postFirebaseRepository: mockPostFirebaseRespository),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Something went Wrong"), findsOneWidget);
    });
  });

  group("Update Post Tests", () {
    testWidgets(
        "given Post Firebase Respository Class when updatePost Func is called and post updated successfully then Post Updated message should display",
        (tester) async {
      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      when(() => mockPostFirebaseRespository.updatePost(any(), any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Post Updated Successfully";
      });

      await tester.pumpWidget(MaterialApp(
        home: UpdatePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final titleTextField = find.byKey(const Key("postTextFormField"));
      final bodyTextField = find.byKey(const Key("bodyTextFormField"));

      await tester.enterText(titleTextField, "Uptating Title");
      await tester.enterText(bodyTextField, "Updating Body");

      expect(find.text("Uptating Title"), findsOneWidget);

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Post Updated Successfully"), findsOneWidget);
    });

    testWidgets(
        "given Post Firebase Respository Class when updatePost Func is called and Firebase exception occur then Something went Wrong message should display",
        (tester) async {
      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      when(() => mockPostFirebaseRespository.updatePost(any(), any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Firebase Exception";
      });

      await tester.pumpWidget(MaterialApp(
        home: UpdatePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final titleTextField = find.byKey(const Key("postTextFormField"));
      final bodyTextField = find.byKey(const Key("bodyTextFormField"));

      await tester.enterText(titleTextField, "Uptating Title");
      await tester.enterText(bodyTextField, "Updating Body");

      expect(find.text("Uptating Title"), findsOneWidget);

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Firebase Exception"), findsOneWidget);
    });

    testWidgets(
        "given Post Firebase Respository Class when updatePost Func is called and Exception occur then Something went Wrong message should display",
        (tester) async {
      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      when(() => mockPostFirebaseRespository.updatePost(any(), any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Exception";
      });

      await tester.pumpWidget(MaterialApp(
        home: UpdatePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final titleTextField = find.byKey(const Key("postTextFormField"));
      final bodyTextField = find.byKey(const Key("bodyTextFormField"));

      await tester.enterText(titleTextField, "Uptating Title");
      await tester.enterText(bodyTextField, "Updating Body");

      expect(find.text("Uptating Title"), findsOneWidget);

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Exception"), findsOneWidget);
    });
  });

  group("Delete Post Tests", () {
    testWidgets(
        "given Post Firebase Repository Class when Delete Post Func is called and post is deleted successfully then Post Deleted msg should be display.",
        (tester) async {
      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      when(() => mockPostFirebaseRespository.deletePost(any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Post Deleted";
      });

      await tester.pumpWidget(MaterialApp(
        home: DeletePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Post Deleted"), findsOneWidget);
    });

    testWidgets(
        "given Post Firebase Repository Class when Delete Post Func is called and firebase exception occur then Firebase Exception msg should be display.",
        (tester) async {
      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      when(() => mockPostFirebaseRespository.deletePost(any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Firebase Exception";
      });

      await tester.pumpWidget(MaterialApp(
        home: DeletePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Firebase Exception"), findsOneWidget);
    });

    testWidgets(
        "given Post Firebase Repository Class when Delete Post Func is called and generic exception occur then Exception msg should be display.",
        (tester) async {
      bool isLoadingTest = false;
      when(() => mockPostFirebaseRespository.isLoading)
          .thenAnswer((ans) => isLoadingTest);
      when(() => mockPostFirebaseRespository.deletePost(any()))
          .thenAnswer((ans) async {
        isLoadingTest = true;
        await Future.delayed(const Duration(milliseconds: 100));
        isLoadingTest = false;
        return "Exception";
      });

      await tester.pumpWidget(MaterialApp(
        home: DeletePostFView(
            postFirebaseRepository: mockPostFirebaseRespository),
      ));

      final btn = find.byType(ElevatedButton);
      await tester.tap(btn);

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.text("Exception"), findsOneWidget);
    });
  });

  group("Get Posts Tests", () {
    testWidgets(
        "given Post Firebase Repository Class when getPosts Func is called then Posts should display.",
        (tester) async {
      when(() => mockPostFirebaseRespository.getPosts())
          .thenAnswer((ans) async {
        Post post1 = Post(id: 1, userId: 1, title: "Title 1", body: "Body 1");
        Post post2 = Post(id: 2, userId: 2, title: "Title 2", body: "Body 2");
        await Future.delayed(const Duration(milliseconds: 100));
        return [post1, post2];
      });

      await tester.pumpWidget(MaterialApp(
        home:
            GetPostsFView(postFirebaseRepository: mockPostFirebaseRespository),
      ));

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byKey(const Key("title_0")), findsOneWidget);
      expect(find.byKey(const Key("title_1")), findsOneWidget);
      expect(find.byKey(const Key("body_0")), findsOneWidget);
      expect(find.byKey(const Key("body_1")), findsOneWidget);
    });
  });
}
