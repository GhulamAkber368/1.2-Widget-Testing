import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:widget_testing/repository/post_repository.dart';
import 'package:widget_testing/utils/app_urls.dart';
import 'package:widget_testing/view/post/create_post_view.dart';
import 'package:widget_testing/view/post/get_posts_view.dart';

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
    "title": "foo",
    "body": "bar",
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

        await tester.tap(createPostBtn);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.text("Title Text Form Field"), findsOneWidget);
        expect(find.text("Body Text Form Field"), findsOneWidget);
      });
    });
  });
}
