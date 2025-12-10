from otree.api import *
import random
import math

doc = """
Your app description
"""


class C(BaseConstants):
    NAME_IN_URL = 'outro'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1


class Subsession(BaseSubsession):
    pass


class Group(BaseGroup):
    pass


class Player(BasePlayer):
    pass

class Results(Page):
   pass

class Redirect(Page):
        @staticmethod
        def js_vars(player):
            return dict(
                completionlinkfull=
                player.subsession.session.config['completionlinkfull']
            )


page_sequence = [Results, Redirect]
