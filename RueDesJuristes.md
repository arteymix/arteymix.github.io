This project is a big one!

It's done entirely in PHP using the Kohana framework.

This was the first time I would be working with Twig. It was a really nice experience. Development was extremely fast and I would no lie saying it has never bugged me. I did unit testing with PHPUnit and Kohana Request, which is surprisingly efficient.

The project also permit me to upgrade my mailing module. I could consider it as a really nice piece of software. It has a lovely closure syntax:

```
Mailer::factory()
    ->content_type('text/html; charset=utf-8')
    ->subject('Hey Foo!')
    ->body(Twig::factory('some/template'))
    ->send('foo@example.com');
```

It is also parsing recipient list using a nice regex, so you do not have to worry sending more personal mail to your user, even if they have non-ascii username. It the worst case, it default to his email.

## PHPUnit and self-requesting

Kohana is HMVC, which means that you can request any of your page in the execution of any internal ```Request```. This is extremly convenient when testing an application, since it generally ends up being about requesting an endpoint and asserting the new states of your data.

```php

public class HomeTest extends Unittest_TestCase {

    testIndex() {

        $response = Request::factory('')->execute();

        $this->assertEquals(200, $response->status());
        $this->assertTag(array('tag' => 'h1', 'content' => 'Hello world!'), $response->body());
        // ...
}
```

Even the mail module is fully testable using ```Mail_Sender_Mock```.

```php

public class HomeTest extends Unittest_TestCase {

    testIndex() {

        $response = Request::factory('')
            ->method(Request::POST)
            ->execute();

        $mail = array_pop(Mail_Sender_Mock::$history);

        $this->assertEquals('text/html', $mail->content_type());
        $this->assertTag(array('tag' => 'h1', 'content' => 'Hello world!'), $mail->body());
        // ...
}
```