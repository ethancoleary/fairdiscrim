from otree.api import *


doc = """
Your app description
"""


class C(BaseConstants):
    NAME_IN_URL = 'task'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1
    CORRECT_ANSWERS = [1, 3, 150, 2]


class Subsession(BaseSubsession):
    pass


class Group(BaseGroup):
    pass


class Player(BasePlayer):
    investment = models.IntegerField(min=0,max=200)
    check1 = models.IntegerField(
        choices=[
            [1, 'A'],
            [2, 'B']
        ],
        widget=widgets.RadioSelect
    )
    check2 = models.IntegerField(
        choices=[
            [1, 'You will earn 1 cent for every 5 tokens earned from lotteries'],
            [2, 'You will earn 1 cent for every 5 tokens invested by both individuals'],
            [3, 'You will earn 1 cent for every 5 tokens invested by the individual you give 300 tokens to']
        ],
        widget=widgets.RadioSelect
    )
    check3 = models.IntegerField()
    check4 = models.IntegerField(
        choices=[
            [1, 'True'],
            [2, 'False']
        ],
        widget=widgets.RadioSelect
    )

    task = models.IntegerField(
        choices=[
            [1, 'Individual A'],
            [2, 'Individual B']
        ]
    )
    incorrect1 = models.IntegerField(initial=0)
    incorrect2 = models.IntegerField(initial=0)
    incorrect3 = models.IntegerField(initial=0)
    incorrect4 = models.IntegerField(initial=0)



# PAGES
class TaskIntro1(Page):
    pass
class CompCheck(Page):
    form_model = 'player'
    form_fields = ['check1', 'check2', 'check3', 'check4']

    @staticmethod
    def error_message(player, values):
        if values['check1'] != C.CORRECT_ANSWERS[0]:
            player.incorrect1 = 1
            return ('Your answer to question 1 is wrong. Individuals from group A invested more than those from group B.')

        elif values['check2'] != C.CORRECT_ANSWERS[1]:
            player.incorrect2 = 1
            return (
                'Your answer to question 2 is wrong. Your bonus payment is a commission on all tokens invested by all individuals.')

        elif values['check3'] != C.CORRECT_ANSWERS[2]:
            player.incorrect3 = 1
            return (
                'Your answer to question 3 is wrong. The expected return to investing in the lottery is 150% i.e. on average investors make money from investing.')

        elif values['check4'] != C.CORRECT_ANSWERS[3]:
            player.incorrect4 = 1
            return (
                'Your answer to question 4 is wrong. You receive your commission for investmensts made, not money earned so it does not matter if the investments are successful.')



class Task(Page):
    form_model = 'player'
    form_fields = ['task']

    @staticmethod
    def before_next_page(player, timeout_happened):
        participant = player.participant
        participant.task = player.task



page_sequence = [
                TaskIntro1,
                CompCheck,
                Task
                ]
