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
    fairscenario=models.IntegerField(
        choices = [
        [1, 'Extremely fair'],
        [2, 'Somewhat fair'],
        [3, 'Slightly fair'],
        [4, 'Neither fair nor unfair'],
        [5, 'Slightly unfair'],
        [6, 'Somewhat unfair'],
        [7, 'Extremely unfair'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    fairgender=models.IntegerField(
        choices = [
        [1, 'Extremely fair'],
        [2, 'Somewhat fair'],
        [3, 'Slightly fair'],
        [4, 'Neither fair nor unfair'],
        [5, 'Slightly unfair'],
        [6, 'Somewhat unfair'],
        [7, 'Extremely unfair'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    matchinvest=models.IntegerField(min=0,max=300)
    income=models.IntegerField(min=1, max=10)
    merit=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    fairopps=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    importantopps=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    ineqjust=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    intervene=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    possiblefair=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    check1=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    women=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    minorities=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    selecproc=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    discrim=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    groupinfo=models.IntegerField(
        choices = [
        [1, 'Strongly Disagree'],
        [2, 'Somewhat Disagree'],
        [3, 'Slightly Disagree'],
        [4, 'Neither Disagree nor Agree'],
        [5, 'Slightly Agree'],
        [6, 'Somewhat Agree'],
        [7, 'Extremely Agree'],
        [8, 'I do not know']
    ],
        widget=widgets.RadioSelect
    )
    risk=models.IntegerField(min=1, max=10)
    lottery = models.IntegerField()

class Question1(Page):
    form_model = 'player'
    form_fields = ['fairscenario', 'fairgender', 'matchinvest',]


    @staticmethod
    def vars_for_template(player):
        participant=player.participant

        budget = 100 + 200 * participant.receive
        matchbudget = 100 + 200 * (1-participant.receive)

        return {
            'budget': budget,
            'matchbudget': matchbudget
        }




    #@staticmethod
    #def is_displayed(player):
    #    return player.participant.receive == 0

class Question2(Page):
    form_model = 'player'
    form_fields = [
        'income'
    ]

    #@staticmethod
   # def is_displayed(player):
        #return player.participant.receive == 0

class Question3(Page):
    form_model = 'player'
    form_fields = [
        'merit',
        'fairopps',
        'importantopps',
        'ineqjust',
        'intervene',
        'possiblefair'
    ]

    # def is_displayed(player):
    # return player.participant.receive == 0

class Question4(Page):
    form_model = 'player'
    form_fields = [
        'women',
        'minorities',
        'selecproc',
        'discrim',
        'groupinfo'
    ]


class Question5(Page):
    form_model = 'player'
    form_fields = [
        'risk'
    ]

class Results(Page):

    @staticmethod
    def vars_for_template(player):
        participant = player.participant

        inv = participant.investment
        die = participant.die

        if participant.receive == 1:
            kept = 300 - participant.investment
        else:
            kept = 100 - participant.investment

        if die < 3 :
            player.lottery = 1
            earning = math.ceil(2.5 * inv) + kept
        else:
            player.lottery = 0
            earning = kept

        if earning % 10 == 0:
            bonus = f"{earning / 100}0"
        else:
            bonus = f"{earning / 100}"

        if participant.receive == 0:
            participation_fee = 0
        else:
            if participant.pilottreatment == 1:
                if participant.steal == 1:
                    participation_fee = 1
                else:
                    participation_fee = 0.5

            elif participant.pilottreatment == 2:
                if participant.steal == 1:
                    participation_fee = 0.75
                else:
                    participation_fee = 0.5

            elif participant.pilottreatment == 3:
                    participation_fee = 0.5

            elif participant.pilottreatment == 4:
                if participant.steal == 1:
                    participation_fee = 0.25
                else:
                    participation_fee = 0.5

        if participation_fee % 10 == 0:
            participation_fee = f"{participation_fee / 100}0"
        else:
            participation_fee = f"{participation_fee / 100}"

        return {
            'kept': kept,
            'inv': inv,
            'die': die,
            'earning': earning,
            'bonus': bonus,
            'participation_fee': participation_fee

        }
class Redirect(Page):
        @staticmethod
        def js_vars(player):
            return dict(
                completionlinkfull=
                player.subsession.session.config['completionlinkfull']
            )




page_sequence = [
    Question1,
    Question2,
    Question3,
    Question4,
    Question5,
    Results,
    Redirect
]
