# retina-sdk.rb - A Ruby Client for the Cortical.io Retina API

Pure Ruby wrapper library for [Cortical.io's Retina API](http://api.cortical.io/). Register for a
[free API key](http://www.cortical.io/resources_apikey.html) and include retina-sdk.rb to add language intelligence to
your application.

## Introduction

Cortical.io's Retina API allows the user to perform semantic operations on text. One can for example:

* measure the semantic similarity between two written entities
* create a semantic classifier based on positive and negative example texts
* extract keywords from a text
* divide a text into sub-sections corresponding to semantic changes
* extract terms from a text based on part of speech tags

The meaning of terms and texts is stored in a sparse binary representation that allows the user to apply logical
operators to refine the semantic representation of a concept.

You can read more about the technology at the [documentation page](http://documentation.cortical.io/intro.html).

To access the API, you will need to register for an [API key](http://www.cortical.io/resources_apikey.html).


## Installation

The client is available as a regular Ruby gem and can be installed as follows:

Add this line to your application's Gemfile:
```sh
    gem 'retina-sdk'
```
And then execute:
```sh
    $ bundle
```
Or install it yourself as:
```sh
    $ gem install retina-sdk
```
This gem will not pull in any other library.

*IMPORTANT NOTE*
This client is compatibale with Ruby 2.0 and above. It won't run with Ruby 1.8 or 1.9. It is compatible with 2.x.x versions of
[cortical.io's api](http://api.cortical.io)</a>.

## Usage

**retina-sdk.rb** offers two abstractions of the Cortical.io Retina API, a lightweight module that offers simplified
access to the most common and useful API functions available and a full version module that gives the user complete
control over various parameter settings and complete access to all API endpoints.

### LiteClient Module

The LiteClient module is sufficient for most applications and offers the ability to quickly and easily
compute keywords for a text, semantically compare two texts, retrieve similar terms, create category filters for
semantic filtering and generate semantic fingerprints of a given text. To get started, create an instance of the
lightweight client by passing your API key as follows:  

```ruby
require 'retina-sdk'
lite_client = RetinaSDK::LiteClient.new("your_api_key")
```

The `lite_client` object has 5 methods for accessing the API. You can:

* Convert text into a semantic fingerprint, which is a list of integers (here shortened):
```ruby
> lite_client.get_fingerprint("Ruby is a widely used general-purpose, high-level programming language.")
[1, 3, 7, 8, 33, 35, 65, 66, 68, 69, 70, 71, 72, 77, 79, 89, 117, ..., 16380, 16381, 16382]
```


* Retrieve similar terms for a text (or a fingerprint):
```ruby
> lite_client.get_similar_terms("ruby")
["ruby", "implementations", "perl", "javascript", "scripting", "feels", "programmers", "lets", "python", "plugins", "html", "thinks", "compiler", "files", "api", "max", "bugs", "gets", "adds", "lucas"]
```

* Get the keywords of a text:
```ruby
> lite_client.get_keywords("Vienna is the capital and largest city of Austria, and one of the nine states of Austria")
['austria', 'vienna']
```

* Compute the similarity (in the range [0;1]) between two texts (here just terms to keep the example short), or
any combination of texts and fingerprints:
```ruby
> lite_client.compare("apple", "microsoft")
0.4024390243902438
> lite_client.compare(lite_client.get_fingerprint("apple"), lite_client.get_fingerprint("microsoft"))
0.4024390243902438
> lite_client.compare(lite_client.get_fingerprint("apple"), "microsoft")
0.4024390243902438
```

* Construct a composite Fingerprint from a list of texts (here just terms to keep the example short), and use
 the filter to compare and classify new texts:
```ruby
neurology_filter = lite_client.create_category_filter(["neuron", "synapse", "neocortex"])
> lite_client.compare(neurology_filter, "cortical column")
0.35455851788907006 # high semantic similarity -> poitive classification
> lite_client.compare(neurology_filter, "skylab")
0.056544622895956895 # low semantic similarity -> negative classification
```

### FullClient Module

Using this client, you will have access to the full functionality of
[Cortical.io's Retina API](http://api.cortical.io/).

As with the LiteClient, the FullClient must be instantiated with a valid Cortical.io API key, but you can also change
the default host address (in case you have your own
[AWS](https://aws.amazon.com/marketplace/seller-profile?id=c88ca878-a648-464c-b29b-38ba057bd2f5) instance),
as well as which retina to use.

```ruby
require 'retina-sdk'
full_client = RetinaSDK::FullClient.new("your_api_key", api_server: "http://api.cortical.io/rest", retina_name: "en_associative")```

On the full client, you get responses back in accordance with the response objects delivered from the
[REST api](http://api.cortical.io/). For
example calling `get_terms` will return a list of `Term` objects, and `compare` will return a `Metric` object:

```ruby
> full_client.get_terms(term="ruby")
[Term(@fingerprint=Fingerprint(@positions=[]), @term="ruby", @df=0.00031801664007613897, @pos_types=["NOUN"], @score=0.0)]

> require 'json'
> full_client.compare(JSON.dump([{"term" => "synapse"}, {"term" => "skylab"}]))
Metric(@cosine_similarity=0.032885723350542136, @jaccard_distance=0.9836956521739131, @overlapping_all=6, @overlapping_left_right=0.02631578947368421, @overlapping_right_left=0.0410958904109589, @size_left=228, @size_right=146, @weighted_scoring=0.6719223186964691, @euclidean_distance=0.9679144385026738)
```

All return types are defined in modules in the source folder `retina-sdk/model/`. Please visit the
[REST api](http://api.cortical.io/) for more details about return types, or consult the documentation of the methods
of the `full_client`.


#### Semantic Expressions

The semantic fingerprint is the basic unit within the Retina API. A text or a term can be resolved into a fingerprint
 using the API. Fingerprints can also be combined in *expressions*, and a number of methods
 expect input in our expression language. This is explained in more detail [here](http://documentation.cortical.io/the_power_of_expressions.html).

Expressions are essentially `json` strings with reserved keys: `term`, `text`, and `positions`.
In the previous example, we note that the `compare` function takes as argument a list of two such expressions.
In Ruby we can create an array of two hashes with (in this case) `term` elements and use
the `json` module to convert it to a valid `json` string (`JSON.dump()`). You can however also create the string yourself:

```ruby
> full_client.compare('[{"term": "synapse"}, {"term": "skylab"}]')
Metric(@cosine_similarity=0.032885723350542136, @jaccard_distance=0.9836956521739131, @overlapping_all=6, @overlapping_left_right=0.02631578947368421, @overlapping_right_left=0.0410958904109589, @size_left=228, @size_right=146, @weighted_scoring=0.6719223186964691, @euclidean_distance=0.9679144385026738)
```

#### FullClient Example Usage

Please note that in the Ruby version, the client uses the conventional snake case notation for method names. The required parameters in method calls are passed as
regular parameters whereas the optional uses named parameters (see examples below).

```ruby
require 'json'

# Retrieve a list of all available Retinas
full_client.get_retinas()

# Retrieve information about a specific term
full_client.get_terms(term="ruby")

# Get contexts for a given term
full_client.get_contexts_for_term("ruby", max_results: 3)

# Get similar terms and their Fingerprints for a given term
full_client.get_similar_terms_for_term("ruby", get_fingerprint: true)

# Encode a text into a Semantic Fingerprint
full_client.get_fingerprint_for_text("Ruby is a widely used general-purpose, high-level programming language.")

# Return keywords from a text
full_client.get_keywords_for_text("Ruby is a widely used general-purpose, high-level programming language.")

# Returns tokens from an input text (NOTE: the pos_tags parameter is called POStag in the rest API
# but method parameters in Ruby can start with a capital letter)
full_client.get_tokens_for_text("Ruby is a widely used general-purpose, high-level programming language.", pos_tags: "NN,NNP")

# Slice the input text according to semantic changes (works best on larger texts of at least several sentences)
full_client.get_slices_for_text("longer text with several sentences...")

# Return Semantic Fingerprints for numerous texts in a single call
full_client.get_fingerprints_for_texts(["first text", "second text"])

# Detect the language for an input text
full_client.get_language_for_text("Dieser Text ist auf Deutsch")

# Return the Fingerprint for an input expression
full_client.get_fingerprint_for_expression(JSON.dump({"text" => "Ruby is a widely used general-purpose, high-level programming language."}))

# Return contexts for an input expression
full_client.get_contexts_for_expression(JSON.dump({"text" => "Ruby is a widely used general-purpose, high-level programming language."}))

# Return similar terms for an input expression
full_client.get_similar_terms_for_expression(JSON.dump({"text" => "Ruby is a widely used general-purpose, high-level programming language."}))

# Return Fingerprints for multiple semantic expressions
full_client.get_fingerprints_for_expressions(JSON.dump([{"text" => "first text"}, {"text" => "second text"}]))

# Return contexts for multiple semantic expressions
full_client.get_contexts_for_expressions(JSON.dump([{"text" => "first text"}, {"text" => "second text"}]))

# Return similar terms for multiple semantic expressions
full_client.get_similar_terms_for_expressions(JSON.dump([{"text" => "first text"}, {"text" => "second text"}]))

# Compute the semantic similarity of two input expressions
full_client.compare(JSON.dump([{"term" => "synapse"}, {"term" => "skylab"}]))

# Make multiple comparisons in a single call
comparison1 = [{"term" => "synapse"}, {"term" => "skylab"}]
comparison2 = [{"term" => "mir"}, {"text" => "skylab was a space station"}]
full_client.compare_bulk(JSON.dump([comparison1, comparison2]))

# Create an image from an expression
image_data = full_client.get_image(JSON.dump({"term" => "ruby"}), plot_shape: "square")

# Create multiple images from multiple expressions in a single call
full_client.get_images(JSON.dump([{"text" => "first text"}, {"text" => "second text"}]))

# Create a composite image showing the visual overlap between two expressions
full_client.compare_image(JSON.dump([{"text" => "first text"}, {"text" => "second text"}]))

# Create a filter Fingerprint from positive (related) and negative (unrelated) example texts.
full_client.create_category_filter("test", ["Ruby is a widely used general-purpose, high-level programming language."], negative_examples: ["A ruby is a pink to blood-red colored gemstone, a variety of the mineral corundum. Large rubies can fetch higher prices than equivalently sized diamonds."])
```

## Support

For further documentation about the Retina-API and information on cortical.io's 'Retina' technology please see our
[Knowledge Base](http://www.cortical.io/resources_tutorials.html). Also the `tests` folder contains more examples of how to use the
clients.

If you have any questions or problems please visit our [forum](http://www.cortical.io/resources_forum.html).

## Change Log
**v 1.0.0**

* Initial release.
