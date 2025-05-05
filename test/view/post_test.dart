import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widget_testing/repository/post_repository.dart';
import 'package:widget_testing/utils/app_urls.dart';
import 'package:widget_testing/view/post/APIs/create_post_view.dart';
import 'package:widget_testing/view/post/APIs/delete_post_view.dart';
import 'package:widget_testing/view/post/APIs/get_posts_view.dart';
import 'package:widget_testing/view/post/APIs/patch_post_view.dart';
import 'package:widget_testing/view/post/APIs/update_post_view.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late PostRepository postRepository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    postRepository = PostRepository(mockHttpClient);
  });

  group("Post View Widget Tests", () {
    group("Get Tests", () {
      testWidgets(
          'given Post Repository Class when getPosts Func called and satus is 200 then Posts should be displayed',
          (tester) async {
        when(() => mockHttpClient.get(Uri.parse(AppUrls.getPosts)))
            .thenAnswer((ans) async {
          return Response("""
[
    {
        "userId": 1,
        "id": 1,
        "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "body": "quia et suscipitsuscipit recusandae consequuntur expedita et cumreprehenderit molestiae ut ut quas totamnostrum rerum est autem sunt rem eveniet architecto"
    },
    {
        "userId": 1,
        "ida": "2",
        "title": "qui est esse",
        "body": "est rerum tempore vitaesequi sint nihil reprehenderit dolor beatae ea dolores nequefugiat blanditiis voluptate porro vel nihil molestiae ut reiciendisqui aperiam non debitis possimus qui neque nisi nulla"
    }
    ]
    """, 200);
        });

        await tester.pumpWidget(MaterialApp(
          home: PostView(postRepository: postRepository),
        ));

        expect(find.byType(CircularProgressIndicator), findsOne);

        await tester.pumpAndSettle();

        expect(find.byType(ListTile), findsNWidgets(2));
      });

      testWidgets(
          "given Post Repository Clas when getPosts Func is called and status code is not 200 then Something went wrong message should be displayed",
          (tester) async {
        when(() => mockHttpClient.get(Uri.parse(AppUrls.getPosts)))
            .thenAnswer((ans) async {
          return Response("{}", 500);
        });

        await tester.pumpWidget(MaterialApp(
          home: PostView(postRepository: postRepository),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("Something went wrong"), findsOneWidget);
      });

      testWidgets(
          "given Post Repository Class when getPosts Func is called then Loader should be show initially.",
          (tester) async {
        when(() => mockHttpClient.get(Uri.parse(AppUrls.getPosts)))
            .thenAnswer((ans) async {
          return Future.delayed(
              const Duration(seconds: 2), () => Response("{}", 200));
        });

        await tester.pumpWidget(MaterialApp(
          home: PostView(postRepository: postRepository),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });

    group("Post Tests", () {
      testWidgets(
          "given Post Repository Class when Post Func is called and status is 201 then Title and Body should be display on Screen",
          (tester) async {
        // We aer passing dynamic arguments in createPost Func but in Func and stubbing(where) arguments should be same therefore we can't body or headers here we have to send any
        when(() => mockHttpClient.post(
              Uri.parse(AppUrls.createPost),
              headers: any(named: "headers"),
              body: any(named: "body"),
            )).thenAnswer((ans) async {
          // Added wait to test CircularProgressIndicator
          return Future.delayed(
              const Duration(milliseconds: 100), () => Response("""
{
    "title": "fooo",
    "body": "baar",
    "userId": 1
}
""", 201));
        });

        await tester.pumpWidget(MaterialApp(
          home: CreatePostView(postRepository: postRepository),
        ));

        expect(find.text("Create Post"), findsNWidgets(2));

        final createPostBtn = find.byType(ElevatedButton);
        await tester.tap(createPostBtn);

        await tester.pump();

        // Testing Text Form Field validation.
        expect(find.text('Title is required'), findsOneWidget);
        expect(find.text('Body is required'), findsOneWidget);

        // User can type in the title and body fields.
        final titleTextField = find.byKey(const Key("postTextFormField"));
        final bodyTextField = find.byKey(const Key("bodyTextFormField"));
        await tester.enterText(titleTextField, "Title Text Form Field");
        await tester.enterText(bodyTextField, "Body Text Form Field");

        expect(find.text("Title Text Form Field"), findsOneWidget);
        expect(find.text("Body Text Form Field"), findsOneWidget);

        await tester.tap(createPostBtn);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("fooo"), findsOneWidget);
        expect(find.text("baar"), findsOneWidget);
      });

      testWidgets(
          "given Post Repository Class when createPost Func is called and status code is not 201 then Something went Wrong message should be displayed.",
          (tester) async {
        when(() => mockHttpClient.post(Uri.parse(AppUrls.createPost),
            headers: any(named: "headers"),
            body: any(named: "body"))).thenAnswer((ans) async {
          return Future.delayed(
              const Duration(milliseconds: 100), () => Response("{}", 400));
        });

        await tester.pumpWidget(MaterialApp(
          home: CreatePostView(postRepository: postRepository),
        ));

        final createPostBtn = find.byType(ElevatedButton);
        await tester.tap(createPostBtn);

        await tester.pump();

        // Testing Text Form Field validation.
        expect(find.text('Title is required'), findsOneWidget);
        expect(find.text('Body is required'), findsOneWidget);

        final titleTextFormField = find.byKey(const Key("postTextFormField"));
        final bodyTextFormField = find.byKey(const Key("bodyTextFormField"));

        await tester.enterText(titleTextFormField, "Title");
        await tester.enterText(bodyTextFormField, "Body");

        expect(find.text("Title"), findsOneWidget);
        expect(find.text("Body"), findsOneWidget);

        await tester.tap(createPostBtn);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text('Something went Wrong'), findsOneWidget);
      });
    });

    group("Update Post Tests", () {
      testWidgets(
          "given Post Repository Class when updatePost Func is called and status is 200 then updated title and body should be display",
          ((tester) async {
        when(() => mockHttpClient.put(Uri.parse(AppUrls.updatePostUrl),
            headers: any(named: "headers"),
            body: any(named: "body"))).thenAnswer((ans) async {
          return Future.delayed(
              const Duration(milliseconds: 100), () => Response("""
{
  "id": 1,
  "title": "foo",
  "body": "bar",
  "userId": 1
}
""", 200));
        });

        await tester.pumpWidget(MaterialApp(
          home: UpdatePostView(postRepository: postRepository),
        ));

        final updatePostBtn = find.byType(ElevatedButton);
        await tester.tap(updatePostBtn);
        await tester.pump();

        expect(find.text("Title is required"), findsOneWidget);
        expect(find.text("Body is required"), findsOneWidget);

        final titleTextFormField = find.byKey(const Key("postTextFormField"));
        final bodyTextFormField = find.byKey(const Key("bodyTextFormField"));

        await tester.enterText(titleTextFormField, "Updated Title");
        await tester.enterText(bodyTextFormField, "Updated Body");

        expect(find.text("Updated Title"), findsOneWidget);
        expect(find.text("Updated Body"), findsOneWidget);

        await tester.tap(updatePostBtn);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("foo"), findsOneWidget);
        expect(find.text("bar"), findsOneWidget);
      }));

      testWidgets(
          "given Post Repository Class when updatePost Func is called and status code is not 200 then Something went Wrong msg should be display",
          (tester) async {
        when(() => mockHttpClient.put(Uri.parse(AppUrls.updatePostUrl),
            headers: any(named: "headers"),
            body: any(named: "body"))).thenAnswer((ans) async {
          return Future.delayed(
              const Duration(milliseconds: 100), () => Response("{}", 500));
        });

        await tester.pumpWidget(MaterialApp(
          home: UpdatePostView(postRepository: postRepository),
        ));

        final updatePostBtn = find.byType(ElevatedButton);
        await tester.tap(updatePostBtn);
        await tester.pump();

        expect(find.text("Title is required"), findsOneWidget);
        expect(find.text("Body is required"), findsOneWidget);

        final titleTextFormField = find.byKey(const Key("postTextFormField"));
        final bodyTextFormField = find.byKey(const Key("bodyTextFormField"));

        await tester.enterText(titleTextFormField, "Title");
        await tester.enterText(bodyTextFormField, "Body");

        expect(find.text("Title"), findsOneWidget);
        expect(find.text("Body"), findsOneWidget);

        await tester.tap(updatePostBtn);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("Something went Wrong"), findsOneWidget);
      });
    });

    group("Patch Post Tests", () {
      testWidgets(
          "given Post Repository Class when patchPost Func is called and status is 200 then updated Title should be display",
          (tester) async {
        when(() => mockHttpClient.patch(Uri.parse(AppUrls.patchPostUrl),
            headers: any(named: "headers"),
            body: any(named: "body"))).thenAnswer((ans) async {
          return Future.delayed(
              const Duration(milliseconds: 100), () => Response("""
{
"title": "foodi"
}
""", 200));
        });

        await tester.pumpWidget(MaterialApp(
          home: PatchPostView(postRepository: postRepository),
        ));

        final patchPostBtn = find.byType(ElevatedButton);
        await tester.tap(patchPostBtn);
        await tester.pump();

        expect(find.text("Title is required"), findsOneWidget);
        expect(find.text("Body is required"), findsNothing);

        final postTextFormField = find.byKey(const Key("postTextFormField"));

        await tester.enterText(postTextFormField, "Food");

        expect(find.text("Food"), findsOneWidget);

        await tester.tap(patchPostBtn);

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("foodi"), findsOneWidget);
      });

      testWidgets(
          "given Post Repository Class when patchPost Func is called and status is not 200 then Something went Wrong should be display",
          (tester) async {
        when(() => mockHttpClient.patch(Uri.parse(AppUrls.patchPostUrl),
            headers: any(named: "headers"),
            body: any(named: "body"))).thenAnswer((ans) async {
          return Future.delayed(
              const Duration(milliseconds: 100), () => Response("""
{

}
""", 500));
        });

        await tester.pumpWidget(MaterialApp(
          home: PatchPostView(postRepository: postRepository),
        ));

        final patchPostBtn = find.byType(ElevatedButton);
        await tester.tap(patchPostBtn);
        await tester.pump();

        expect(find.text("Title is required"), findsOneWidget);
        expect(find.text("Body is required"), findsNothing);

        final postTextFormField = find.byKey(const Key("postTextFormField"));

        await tester.enterText(postTextFormField, "Food");

        expect(find.text("Food"), findsOneWidget);

        await tester.tap(patchPostBtn);

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("Something went Wrong"), findsOneWidget);
      });
    });

    group("Delete Post Tests", () {
      testWidgets(
          "given Post Repository Class when deletePost Func is called and status is 200 then Post Delete Successfully should be display",
          (tester) async {
        when(() => mockHttpClient.delete(Uri.parse(AppUrls.deletePostUrl),
            headers: any(named: "headers"),
            body: any(named: "body"))).thenAnswer((ans) async {
          return Future.delayed(
              const Duration(milliseconds: 100), () => Response("{}", 200));
        });

        await tester.pumpWidget(MaterialApp(
          home: DeletePostView(postRepository: postRepository),
        ));

        final deleteBtn = find.byType(ElevatedButton);
        await tester.tap(deleteBtn);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("Post Deleted Successfully"), findsOneWidget);
      });

      testWidgets(
          "given Post Repository Class when deletePost Func is called and status is not 200 then Something went Wrong msg should be display.",
          (tester) async {
        when(() => mockHttpClient.delete(
              Uri.parse(AppUrls.deletePostUrl),
            )).thenAnswer((ans) async {
          return Future.delayed(
              const Duration(milliseconds: 100), () => Response("{}", 500));
        });

        await tester.pumpWidget(MaterialApp(
          home: DeletePostView(postRepository: postRepository),
        ));

        final deletePostbtn = find.byType(ElevatedButton);
        await tester.tap(deletePostbtn);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("Something went Wrong"), findsOneWidget);
      });
    });
  });
}
