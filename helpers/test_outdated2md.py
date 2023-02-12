from pytest import raises

from outdated2md import create_dataframe, produce_md, text_to_blocks

def test_create_dataframe_single():
    src = "This is a sentence"
    translation = "Esto es una frase"
    input_text = [f'#~ msgid "{src}"', f'#~ msgstr "{translation}"']
    result = create_dataframe(input_text)
    assert len(result) == 1
    assert result.columns.to_list() == ['source', 'translation']
    assert result['source'][0] == "This is a sentence"
    assert result['translation'][0] == "Esto es una frase"

def test_create_dataframe_multiple_wrong():
    input_text = ['#~ msgid "This is a sentence"', '#~ msgstr "Esto es una frase"', '#~ msgid "something extra"']
    with raises(ValueError, match="arrays must all be same length"):
        result = create_dataframe(input_text)

def test_create_dataframe_single_reflabel():
    src = "This is a sentence that is translated under `msgstr`"
    translation = "Esto es una frase que se traduce en `msgstr`"
    input_text = [f'#~ msgid "{src}"', f'#~ msgstr "{translation}"']
    result = create_dataframe(input_text)
    assert len(result) == 1
    assert result['source'][0] == src
    assert result['translation'][0] == translation


def test_multilines():
    text = '''#~ msgid ""
#~ "- This is a multi "
#~ "line sentence."
#~ msgstr ""
#~ "- Esto es una frase "
#~ "en varias lineas."
'''

    input_text = text_to_blocks(text)
    result = create_dataframe(input_text)
    assert len(result) == 1
    assert result['source'][0] == "- This is a multi line sentence."
    assert result['translation'][0] == "- Esto es una frase en varias lineas."


def test_multilines_different_lengths():
    text = '''#~ msgid ""
#~ "- This is a multi "
#~ "line sentence."
#~ msgstr "- Esto es una frase en varias lineas."
'''

    input_text = text_to_blocks(text)
    result = create_dataframe(input_text)
    assert len(result) == 1
    assert result['source'][0] == "- This is a multi line sentence."
    assert result['translation'][0] == "- Esto es una frase en varias lineas."

# TODO Other things to test:
# - multiple messages


def test_produce_md():
    src = "This is a sentence"
    translation = "Esto es una frase"
    input_text = [f'#~ msgid "{src}"', f'#~ msgstr "{translation}"']
    result = produce_md(create_dataframe(input_text))
    assert result.splitlines()[2] == f"| {src} | {translation} |"

