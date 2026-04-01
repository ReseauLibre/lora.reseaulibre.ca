# Meetings

{% for nav1 in navigation %}
    {% if nav1.title == "References" %}
        {% for child in nav1.children %}
            {% if child.title == "Meetings" %}
                {% for meeting in child.children %}
- blabla [{{ meeting.title }}]( {{ meeting.canonical_url }} )
                {% endfor %}
            {% endif %}
        {% endfor %}
    {% endif %}
{% endfor %}


foo

<ul>
  {% for nav1 in navigation %}
    {% if nav1.children and nav1.children | length > 1 %}
    <ul>
        {% for nav2 in nav1.children %}
            {% if nav2.url %}
            {% if nav2.title %}
            <li><a href="{{ config.site_url }}{{ nav2.url }}">{{ nav2.title }} </a></li>
            {% endif %}
            {% endif %}

            {% if nav2.children and nav2.children | length > 1 %}
            <ul>
            {% for nav3 in nav2.children %}
                {% if nav3.url %}
                {% if nav3.title %}
                <li><a href="{{ config.site_url }}{{ nav3.url }}">{{ nav3.title }} </a></li>
                {% endif %}
                {% else %}
                {% endif %}
            {% endfor %}
            </ul>
            {% endif %}
        {% endfor %}
        </ul>
    {% endif %}
  {% endfor %}
</ul>

# navigation.pages

{{ navigation.pages }}

# navigation

{{ navigation }}
 
# pretty

{{ context(navigation) | pretty }}
