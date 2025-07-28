from otree.api import *


doc = """
Your app description
"""


class C(BaseConstants):
    NAME_IN_URL = 'task'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1


class Subsession(BaseSubsession):
    pass


class Group(BaseGroup):
    pass


class Player(BasePlayer):
    investment = models.IntegerField(min=0,max=200)


# PAGES
class TaskIntro(Page):
    pass

class Task(Page):
    form_model = 'player'
    form_fields = ['investment']

    @staticmethod
    def before_next_page(player, timeout_happened):
        participant = player.participant
        participant.investment = player.investment



page_sequence = [
                TaskIntro,
                Task
                ]
