import click
from notebook_parameterizer.run import run


@click.command(context_settings=dict(help_option_names=['-h', '--help']))
@click.argument('notebook_path', required=True)
@click.argument('parameters_path', required=True)
@click.option('--output_notebook_path', '-o',
              default=None, help='Path to the parameterized output notebook')
def notebook_parameterizer(
        notebook_path,
        parameters_path,
        output_notebook_path
):
    return run(notebook_path,
               parameters_path,
               output_notebook_path)
