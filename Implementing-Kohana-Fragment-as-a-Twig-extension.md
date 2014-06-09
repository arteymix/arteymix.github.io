I like the Kohana framework, but it's really missing a decent View engine. Sure, PHP-written views are nicely implemented, but that does not just get the job done on sufficiently big project.

I have discovered [Twig](twig.sensiolab.org), everything just became easy and efficient! I was in fact looking for an equivalent templating enging of [jinja2](jinja2.pocoo.org): Twig has the exact same syntax. 

The only ability to declare hierarchical view would have been enough for me. But it has more: filters, embedding, auto-escaping and so on...

Kohana has a [very nice extension for Twig written by tommcdo](https://github.com/tommcdo/kohana-twig).

I did some changes like passing View globals and Twig test support.

Although, I couldn't find a decent caching solution that would bind to Kohana nicely. I did a little of research and I digged to find out I could just extend the Twig framework to implement new tag. Why not a ```fragment``` tag?

First thing I did was to enable custom Twig Extension loading that I would just write down in the Kohana cascading filesystem.

I started by adding an ```extensions``` field in the module configuration:

```php
return array(
    /**
     * Twig Extensions
     */
    'extensions' => array(
        new Twig_Extension_Fragment()
    )
);
```

Twig extension can define new TokenParser. A TokenParser is pretty much a class that is instantiated and called whenever a certain tag it parses is found in the document.

Here, I will parse the `fragment` tag.

```jinja
{% fragment "name" 15 true %}

    {# code here is cached for 15 seconds with the "name" key #}

{% endfragment %}
```

```php
class Twig_TokenParser_Fragment extends Twig_TokenParser {

   public function decideFragmentEnd(Twig_Token $token) {                                                                                            
                                                                                                                                                      
        return $token->test('endfragment');                                                                                                           
    }                                                                                                                                                 
                                                                                                                                                      
    public function getTag() {                                                                                                                        
                                                                                                                                                      
        return 'fragment';                                                                                                                            
    }                                                                                                                                                 
                                                                                                                                                      
    public function parse(Twig_Token $token) {                                                                                                        
                                                                                                                                                      
        $stream = $this->parser->getStream();                                                                                                         
                                                                                                                                                      
        $name = $this->parser->getExpressionParser()->parseExpression();                                                                              
        $lifetime = $this->parser->getExpressionParser()->parseExpression();                                                                          
        $i18n = $this->parser->getExpressionParser()->parseExpression();                                                                              
                                                                                                                                                      
        $stream->expect(Twig_Token::BLOCK_END_TYPE);                                                                                                  
        $body = $this->parser->subparse(array($this, 'decideFragmentEnd'), true);                                                                     
        $stream->expect(Twig_Token::BLOCK_END_TYPE);                                                                                                  
                                                                                                                                                      
        return new Twig_Node_Fragment($name, $lifetime, $i18n, $body, $token->getLine(), $this->getTag());                                            
    }                                                                                                                                                 
                                                                                                                                                      
} 
```

To get your more 
***


* a
* a
* a

```php

```
