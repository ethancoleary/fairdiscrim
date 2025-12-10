from otree.api import *


doc = """
Stage 1 Pilot
"""


class C(BaseConstants):
    NAME_IN_URL = 'intro'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1


class Subsession(BaseSubsession):
    pass


class Group(BaseGroup):
    pass


class Player(BasePlayer):
    consent = models.IntegerField(initial=0)
    gender = models.IntegerField(
        choices=[
            [1, 'Female'],
            [2, 'Male'],
            [3, 'Other'],
            [4, 'Prefer not to say']
        ],
        widget=widgets.RadioSelect
    )
    age = models.IntegerField(min=0, max=100)
    KK = models.IntegerField(
        choices=[
            [1, 'Klee'],
            [2, 'Kandinsky'],
        ],
    )


# PAGES
class Intro(Page):
    form_model = 'player'
    form_fields = ['consent']

    @staticmethod
    def error_message(player, values):
        solutions = dict(consent=1)
        if values != solutions:
            return "Please consent to participation or withdraw from the experiment by closing your browser."


class PDetails(Page):
    form_model = 'player'
    form_fields = ['gender', 'age']
class KK(Page):
    form_model = 'player'
    form_fields = ['KK']


class Results(Page):
    pass


page_sequence = [
                Intro,
                PDetails,
                 KK
                ]
