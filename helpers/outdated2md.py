import pandas as pd


def create_dataframe(outdated_rows):
    data = {'source': [x[10:-1] for x in outdated_rows if "msgid" in x[:10]],
            'translation': [x[11:-1] for x in outdated_rows if "msgstr" in x[:10]]}
    return pd.DataFrame(data)

def produce_md(df):
    return df.to_markdown(index=False)

def text_to_blocks(filetext):
    lines  = filetext.splitlines()
    output = []
    block_text = []
    for line in lines:
        new_block = "#~ msg" in line[:6]
        if new_block:
            if block_text:
                output.append("".join(block_text).replace('"#~ "', ''))
            block_text = []
            block_text.append(line)
        else:
            block_text.append(line)

    if block_text: # We need to get the last block of text!
        output.append("".join(block_text).replace('"#~ "', ''))

    return output

def generate_output(grep_out):
    return produce_md(create_dataframe(text_to_blocks(grep_out)))
