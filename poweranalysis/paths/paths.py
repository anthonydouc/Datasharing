# -*- coding: utf-8 -*-
from pathlib import Path


def get_info_dir():
    
    current_dir = Path(__file__).parents[1]
    
    return Path.joinpath(Path(current_dir), 'info').resolve()


def get_outputs_dir():
    
    current_dir = Path(__file__).parents[2]
    
    return Path(current_dir, Path('outputs')).resolve()


def get_save_dir(output_dir, savepath_rel):
    
    save_dir = Path(output_dir).joinpath(savepath_rel)
   
    save_dir.mkdir(parents=True, exist_ok=True)
    
    return save_dir.resolve()
