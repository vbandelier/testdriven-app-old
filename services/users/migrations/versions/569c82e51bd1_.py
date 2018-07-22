"""empty message

Revision ID: 569c82e51bd1
Revises: c0c676bda5ca
Create Date: 2018-07-22 07:55:34.268211

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '569c82e51bd1'
down_revision = 'c0c676bda5ca'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('password', sa.String(length=255)))
    op.execute('UPDATE users SET password=email')
    op.alter_column('users', 'password', nullable=False)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('users', 'password')
    # ### end Alembic commands ###